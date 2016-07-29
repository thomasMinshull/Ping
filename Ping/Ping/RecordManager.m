//
//  RecordManager.m
//  Ping
//
//  Created by Martin Zhang on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "RecordManager.h"
#import "AverageUUidDuple.h"

#define TIME_INTERVAL 10 * 60

@interface RecordManager ()

//@property (nonatomic, strong) NSOperationQueue *readQueue;
@property (atomic, strong) NSOperationQueue *writeQueue;

//@property (nonatomic, strong) RLMRealm *readRealm;
@property (atomic, strong) RLMRealm *writeRealm;

@end

@implementation RecordManager

- (instancetype)init
{
    self = [super init];
    if (self) {
// No need to init RLMArray?
//        self.timePeriods = [[RLMArray alloc] init];
        _timePeriods = [NSMutableArray array];
        
        // initialize read/write queues
//        self.readQueue = [[NSOperationQueue alloc] init];
        _writeQueue = [[NSOperationQueue alloc] init];
        
        // initialize read/write realms
//        RLMRealmConfiguration *defaultConfiguration = [RLMRealmConfiguration defaultConfiguration];
//        [self.readQueue addOperationWithBlock:^{
//            NSError *error = nil;
//            self.readRealm = [RLMRealm realmWithConfiguration:defaultConfiguration error:&error];
//        }];
        
//        [self.writeQueue addOperationWithBlock:^{
//            NSError *error = nil;
//            self.writeRealm = [RLMRealm realmWithConfiguration:defaultConfiguration error:&error];
//            NSLog(@"Error: %@", error);
//        }];

        _writeRealm = [RLMRealm defaultRealm];

    }
    return self;
}

dispatch_queue_t backgroundQueue() {
    static dispatch_once_t queueCreationGuard;
    static dispatch_queue_t queue;
    dispatch_once(&queueCreationGuard, ^{
        queue = dispatch_queue_create("com.tomm.Ping.backgroundQueue", 0);
    });
    return queue;
}



// convert userProximity string into a int 

-(void)storeBlueToothDataByUUID:(NSString *)userUUID userProximity:(int)proximity andTime:(NSDate *)time {
    dispatch_queue_t queue = backgroundQueue();
    dispatch_async(queue, ^{
        @synchronized (self) {
            RLMRealm *backgroundRealm = [RLMRealm defaultRealm];
            [backgroundRealm transactionWithBlock:^{
                
                TimePeriod *previousTimePeriod = [self.timePeriods lastObject];
                if (previousTimePeriod == nil) {
                    TimePeriod *newTimePeriod = [[TimePeriod alloc] init];
                    UserRecord *newUserRecord = [[UserRecord alloc] initWithUUID:userUUID andDistance:proximity];
                    
                   // RLMRealm *backgroundRealm = [RLMRealm defaultRealm];
                    //[backgroundRealm beginWriteTransaction];
                    
                    newTimePeriod.startTime = [self getStartTimeForTimePeriod:time];
                    [self.timePeriods addObject:newTimePeriod];
                    [newTimePeriod.userRecords addObject:newUserRecord];
                    
                   // [backgroundRealm commitWriteTransaction];
                } else {
                    
                    NSDate *endTime = [previousTimePeriod.startTime dateByAddingTimeInterval:TIME_INTERVAL];
                    
                    if ([time timeIntervalSinceReferenceDate] > [previousTimePeriod.startTime timeIntervalSinceReferenceDate] && [time timeIntervalSinceReferenceDate] < [endTime timeIntervalSinceReferenceDate]) {
                        
                        BOOL foundUser = NO;
                        
                        for (int i = 0; i < previousTimePeriod.userRecords.count; i++) {
                            @synchronized (previousTimePeriod.userRecords[i]) { // prevents race condition
                                UserRecord *aUserRec = previousTimePeriod.userRecords[i];
                                
                                if ([aUserRec.uUID isEqualToString: userUUID]) {
                                    dispatch_queue_t queue = backgroundQueue();
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
                    
                    else if ([time timeIntervalSinceReferenceDate] > [endTime timeIntervalSinceReferenceDate]) {
                        TimePeriod *newTimePeriod = [[TimePeriod alloc] init];
                        UserRecord *newUserRecord = [[UserRecord alloc] initWithUUID:userUUID andDistance:proximity];
                        
                        //RLMRealm *backgroundRealm = [RLMRealm defaultRealm];
                        //[backgroundRealm beginWriteTransaction];
                        
                        newTimePeriod.startTime = [self getStartTimeForTimePeriod:time];
                        [self.timePeriods addObject:newTimePeriod];
                        [newTimePeriod.userRecords addObject:newUserRecord];
                        
                        //[backgroundRealm commitWriteTransaction];
                    }
                }
                NSLog(@"The current time period: %@. The user's UUID: %@. Total distance: %d. Number of obs: %d.", [[self.timePeriods lastObject] startTime], [[[[self.timePeriods lastObject] userRecords]lastObject]uUID], [[[[self.timePeriods lastObject] userRecords]lastObject]totalDistance], [[[[self.timePeriods lastObject] userRecords]lastObject]numberOfObs]);
                //    [self persistToDefaultRealm];
                [self persistToDefaultRealmOnBackgroundThread];
            }];

        }
    });
}
/*
-(void)generateNewTimePeriodAndUserRecordWithUserUUID:(NSString *)uUID proximity:(int)proximity andTime:(NSDate *)time {
    dispatch_queue_t queue = backgroundQueue();
    dispatch_async(queue, ^{
        
        TimePeriod *newTimePeriod = [[TimePeriod alloc] init];
        UserRecord *newUserRecord = [[UserRecord alloc] initWithUUID:uUID andDistance:proximity];
        
        RLMRealm *backgroundRealm = [RLMRealm defaultRealm];
        [backgroundRealm beginWriteTransaction];
       
        newTimePeriod.startTime = [self getStartTimeForTimePeriod:time];
        [self.timePeriods addObject:newTimePeriod];
        [newTimePeriod.userRecords addObject:newUserRecord];
        
        [backgroundRealm commitWriteTransaction];
    });
    
}
*/
-(void)increaseUserTotalDistanceAndObs:(UserRecord *)userRecord userProximity:(int)proximity {
    dispatch_queue_t queue = backgroundQueue();
    dispatch_async(queue, ^{
        // [self.writeRealm beginWriteTransaction];
        
        RLMRealm *backgroundRealm = [RLMRealm defaultRealm];
        [backgroundRealm beginWriteTransaction];
        userRecord.totalDistance += proximity;
        userRecord.numberOfObs ++;
        [backgroundRealm commitWriteTransaction];
        
       // [self.writeRealm commitWriteTransaction];
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

-(void)persistToDefaultRealm {
    
//    [self.writeQueue addOperationWithBlock:^{
//        RLMRealm *defaultRealm = [RLMRealm defaultRealm];
    dispatch_queue_t queue = backgroundQueue();
    dispatch_async(queue, ^{
        [self.writeRealm beginWriteTransaction];
        [self.writeRealm addObjects:self.timePeriods];
        [self.writeRealm commitWriteTransaction];
    });
//    }];

//    [self.readQueue addOperationWithBlock:^{
//        <#code#>
//    }];
}

-(void)persistToDefaultRealmOnBackgroundThread {
    dispatch_queue_t queue = backgroundQueue();
    dispatch_async(queue, ^{
        RLMRealm *backgroundRealm = [RLMRealm defaultRealm];
        [backgroundRealm beginWriteTransaction];
        [backgroundRealm addObjects:self.timePeriods];
        [backgroundRealm commitWriteTransaction];
        // Using previous global realm object for saving
//        [self.writeRealm beginWriteTransaction];
//        [self.writeRealm addObjects:self.timePeriods];
//        [self.writeRealm commitWriteTransaction];
    });
}

-(NSMutableArray *)sortingUserRecordsInTimePeriodByProximity:(NSDate *)date {
    
    date = [self getStartTimeForTimePeriod:date]; // rounds down to correct start date
    
//    TimePeriod *aTimePeriod = [TimePeriod new];
//    aTimePeriod.startTime = date;
    
    // FETCH IT FROM REALM
//    self.timePeriods = [[TimePeriod allObjects] mutableCopy];
    
//    for (TimePeriod *tp in self.timePeriods) {

    for (TimePeriod *tp in [TimePeriod allObjects]) {
        if (date == tp.startTime) { // This is the time period you are looking for
            NSMutableArray *userRecordsArrayInTimePeriod = [[NSMutableArray alloc] init];
            
            for (UserRecord *aUserRecord in tp.userRecords) {
                AverageUUidDuple *duple = [AverageUUidDuple new];
                duple.userAverage = aUserRecord.totalDistance / aUserRecord.numberOfObs;
                duple.uUID = aUserRecord.uUID;
                [userRecordsArrayInTimePeriod addObject:duple];
                
               // aUserRecord.userAverage = aUserRecord.totalDistance / aUserRecord.numberOfObs;
               // [userRecordsArrayInTimePeriod addObject:aUserRecord];
                
            }
            
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"userAverage" ascending:YES];
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

@end














