//
//  currentUser.m
//  Ping
//
//  Created by thomas minshull on 2016-08-09.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "currentUser.h"

@implementation CurrentUser

+ (CurrentUser *)getCurrentUser {
    RLMResults<CurrentUser *> *currentUsers = [CurrentUser allObjects];
    if ([currentUsers count] > 0) {
        CurrentUser *currentUser = [currentUsers firstObject];
        return currentUser;
    }
    return nil;
}

+ (CurrentUser *)makeCurrentUserWithProfileDictionary:(NSDictionary *)dic {
    RLMRealm *currentUserRealm = [RLMRealm defaultRealm];
    
    [currentUserRealm beginWriteTransaction];
    CurrentUser *currentUser = [CurrentUser new];
    [currentUser setPropertiesWithProfileDictionary:dic];
    [currentUserRealm commitWriteTransaction];
    
    return currentUser;
}

- (void)save {
    RLMRealm *currentUserRealm = [RLMRealm defaultRealm];
    [currentUserRealm beginWriteTransaction];
    [currentUserRealm deleteAllObjects];
    [currentUserRealm addObject:self];
    [currentUserRealm commitWriteTransaction];
}

@end
