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
    
    PFObject *parseUser = [PFObject objectWithClassName:@"User"];
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


#pragma mark -Private Methods

- (void)addEvent:(Event *)event {
    RLMRealm *currentUserRealm = [RLMRealm defaultRealm];
    
    [currentUserRealm transactionWithBlock:^{
        [self.events addObject:event];
    }];

}

- (void)save { // not sure if used can propbably delete
    
    RLMRealm *currentUserRealm = [RLMRealm defaultRealm];

    [currentUserRealm transactionWithBlock:^{
        [currentUserRealm deleteAllObjects];
        [currentUserRealm addObject:self];
    }];
    
}


@end
