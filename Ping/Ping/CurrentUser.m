//
//  currentUser.m
//  Ping
//
//  Created by thomas minshull on 2016-08-09.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "currentUser.h"
#import <Parse/Parse.h>
#import "RecordManager.h"

@implementation CurrentUser

#pragma mark -Public Methods

+ (CurrentUser *)getCurrentUser {
    RLMResults<CurrentUser *> *currentUsers = [CurrentUser allObjects];
   
    if ([currentUsers count] > 0) {
        CurrentUser *currentUser = [currentUsers firstObject];
        return currentUser;
    }
    
    return nil;
}

+ (CurrentUser *)makeCurrentUserWithProfileDictionary:(NSDictionary *)dic {
    CurrentUser *currentUser = [CurrentUser new];
    [currentUser setPropertiesWithProfileDictionary:dic];
    [currentUser save];
    
    PFObject *parseUser = [PFObject objectWithClassName:@"ParseUser"];
    parseUser[@"firstName"] = currentUser.firstName;
    parseUser[@"lastName"] = currentUser.lastName;
    parseUser[@"headline"] = currentUser.headline;
    parseUser[@"linkedInID"] = currentUser.linkedInID;
    parseUser[@"UUID"] = currentUser.UUID;
    if (currentUser.profilePicURL) {
        parseUser[@"profilePicURL"] = currentUser.profilePicURL;
    }
    
    [parseUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"current user saved in parse");
        } else {
            NSLog(@"Failed to save current user in parse. ERROR: %@", error);
        }
    }];
    return currentUser;
}

#pragma mark -Instance Methods

- (void)addEvent:(Event *)event {
    
    //schedule bluetooth
    
    NSTimeInterval secondsPerHalfAnHour = 60 * 30;
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Your event is starting soon!";
    notification.alertAction = @"open"; //slide to notification.alertAction
    NSDate *halfAnHourBefore = [event.startTime dateByAddingTimeInterval:-secondsPerHalfAnHour];
    notification.fireDate = halfAnHourBefore;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.category = @"BT_CATEGORY";
    
//    UILocalNotification *notification1 = [[UILocalNotification alloc] init];
//    notification1.alertBody = @"Your Bluetooth is not turned off!";
//    notification1.fireDate = event.endTime;
//    notification1.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    NSLog(@"!!Saved notification!! %@", [notification description]);
    
    
    //save event
    
    RLMRealm *currentUserRealm = [RLMRealm defaultRealm];
    
    [currentUserRealm transactionWithBlock:^{
        [self.events addObject:event];
    }];

}


- (NSArray *)fetchEvents {
    RLMResults<Event *> *events = [Event allObjects];
    NSMutableArray *eventsToPass = [[NSMutableArray alloc] init];
    for (Event *event in events) {
        [eventsToPass addObject:event];
    }
    return [eventsToPass copy];
}


- (void)save { // not sure if used can propbably delete
    
    RLMRealm *currentUserRealm = [RLMRealm defaultRealm];

    [currentUserRealm transactionWithBlock:^{
        [currentUserRealm deleteAllObjects];
        [currentUserRealm addObject:self];
    }];
    
}


@end
