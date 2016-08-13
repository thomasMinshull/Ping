//
//  RecordManager.m
//  Ping
//
//  Created by Martin Zhang on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "RecordManager.h"
#import "AverageUUidDuple.h"
#import "User.h"

#define TIME_INTERVAL 10 * 60

@interface RecordManager ()

@property (strong) RLMArray<User *><User> *users;

@end

@implementation RecordManager

- (dispatch_queue_t)backgroundQueue {
    static dispatch_once_t queueCreationGuard;
    static dispatch_queue_t queue;
    dispatch_once(&queueCreationGuard, ^{
        queue = dispatch_queue_create("com.tomm.Ping.backgroundQueue", 0);
    });
    return queue;
}


#pragma mark - BlueTooth Montioring Methods

// convert userProximity string into a int

-(void)storeBlueToothDataByUUID:(NSString *)userUUID userProximity:(int)proximity andTime:(NSDate *)time {
    dispatch_queue_t queue = self.backgroundQueue;
    dispatch_async(queue, ^{
        @synchronized (self) {
            RLMRealm *backgroundRealm = [RLMRealm defaultRealm];
            [backgroundRealm transactionWithBlock:^{
                
                TimePeriod *previousTimePeriod = [[TimePeriod objectsWhere:@"startTime = %@", [self getStartTimeForTimePeriod:time]] firstObject];
                
                if (previousTimePeriod == nil) { // Didn't find a time Period for this time, lets make one!
                    TimePeriod *newTimePeriod = [[TimePeriod alloc] init];
                    UserRecord *newUserRecord = [[UserRecord alloc] initWithUUID:userUUID andDistance:proximity];
                    
                    newTimePeriod.startTime = [self getStartTimeForTimePeriod:time];
                    [newTimePeriod.userRecords addObject:newUserRecord];
                    [backgroundRealm addObject:newTimePeriod];

                } else {
                    NSDate *endTimeDate = previousTimePeriod.startTime;
                    NSDate *endTime = [endTimeDate dateByAddingTimeInterval:TIME_INTERVAL];
                    
                    if ([time timeIntervalSinceReferenceDate] > [previousTimePeriod.startTime timeIntervalSinceReferenceDate] && [time timeIntervalSinceReferenceDate] < [endTime timeIntervalSinceReferenceDate]) { //Found a time period where this start time, This should be the current time period, but we're double checking to be safe
                        
                        BOOL foundUser = NO;
                        
                        for (int i = 0; i < previousTimePeriod.userRecords.count; i++) {
                            @synchronized (previousTimePeriod.userRecords[i]) { // prevents race condition
                                UserRecord *aUserRec = previousTimePeriod.userRecords[i];
                                
                                if ([aUserRec.uUID isEqualToString: userUUID]) {
                                    dispatch_queue_t queue = self.backgroundQueue;
                                    dispatch_async(queue, ^{
                                        RLMRealm *backgroundRealm = [RLMRealm defaultRealm];
                                        [backgroundRealm beginWriteTransaction];
                                        aUserRec.totalDistance += proximity;
                                        aUserRec.numberOfObs ++;
                                        [backgroundRealm commitWriteTransaction];
                                    });
                                    foundUser = YES;
                                }
                            }
                        }

                        
                        if (foundUser == NO) {
                            UserRecord *newRecord = [[UserRecord alloc] initWithUUID:userUUID andDistance:proximity];
                            [previousTimePeriod.userRecords addObject:newRecord];
                        }
                    }
                    
                    else if ([time timeIntervalSinceReferenceDate] > [endTime timeIntervalSinceReferenceDate]) { // Wow, we are passed the end time for this time interval, beter create a new one
                        TimePeriod *newTimePeriod = [[TimePeriod alloc] init];
                        UserRecord *newUserRecord = [[UserRecord alloc] initWithUUID:userUUID andDistance:proximity];
                        
                        newTimePeriod.startTime = [self getStartTimeForTimePeriod:time];
                        [backgroundRealm addObject:newTimePeriod];
                        [newTimePeriod.userRecords addObject:newUserRecord];
                        
                    }
                }

            }];

        }
    });
}

-(NSDate *)getStartTimeForTimePeriod:(NSDate *)time{
    NSCalendar *cal = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]; // get calander
    NSDateComponents *newDateComponenet = [[NSDateComponents alloc] init]; // create new component
    
    NSDateComponents *minComponent = [cal components:(NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitNanosecond) fromDate:time]; // get the components from time passed in
    
    // flip sign on seconds and nanoseconds (this will zero out these values)
    newDateComponenet.second = (-1)*minComponent.second;
    newDateComponenet.nanosecond = (-1)*minComponent.nanosecond;
    // round down the minutes
    newDateComponenet.minute = (-1) * (minComponent.minute %10);
    
    // apply the adjusted components to the passed in date to return the new date
    return [cal dateByAddingComponents:newDateComponenet toDate:time options:0];
    
}

-(NSMutableArray *)sortingUserRecordsInTimePeriodByProximity:(NSDate *)date {
    
    date = [self getStartTimeForTimePeriod:date]; // rounds down to correct start date

    for (TimePeriod *tp in [TimePeriod allObjects]) {
        if (date == tp.startTime) { // This is the time period you are looking for
            NSMutableArray *userRecordsArrayInTimePeriod = [[NSMutableArray alloc] init];
            
            for (UserRecord *aUserRecord in tp.userRecords) {
                AverageUUidDuple *duple = [AverageUUidDuple new];
                duple.userAverage = aUserRecord.totalDistance / aUserRecord.numberOfObs;
                duple.uUID = aUserRecord.uUID;
                [userRecordsArrayInTimePeriod addObject:duple];
            }
            
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"userAverage" ascending:NO];
            userRecordsArrayInTimePeriod = [[userRecordsArrayInTimePeriod sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
            
            NSMutableArray *uuidArray = [NSMutableArray new];
            for (AverageUUidDuple *dup in userRecordsArrayInTimePeriod) {
                [uuidArray addObject:dup.uUID];
            }
            
            return uuidArray;
        }
    }
    return nil;
}

- (void)backUpUsers:(NSMutableSet *)users {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        for (User *user in users) {
            [self.users addObject:user];
        }
    }];
}

- (NSArray *)uuidList {
    NSMutableArray *array = [[NSMutableArray alloc] init];

    RLMResults<User *> *users = [User allObjects];
    for (User *user in users) {
        NSString *uuidString = user.UUID;
        [array addObject:uuidString];
    }
    return [array copy];
}


@end














