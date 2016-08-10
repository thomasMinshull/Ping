//
//  currentUser.m
//  Ping
//
//  Created by thomas minshull on 2016-08-09.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "currentUser.h"
#import "Backendless.h"
#import "BackendlessUser.h"

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
    CurrentUser *currentUser = [CurrentUser new];
    [currentUser setPropertiesWithProfileDictionary:dic];
    
    //register user in backendless
    BackendlessUser *backendUser = [BackendlessUser new];
    [backendUser setProperty:@"Password" object:currentUser.UUID];
    [backendUser setProperty:@"firstName" object:currentUser.firstName];
    [backendUser setProperty:@"lastName" object:currentUser.lastName];
    [backendUser setProperty:@"headline" object:currentUser.headline];
    [backendUser setProperty:@"linkedInID" object:currentUser.linkedInID];
    if (currentUser.profilePicURL) {
        [backendUser setProperty:@"profilePicURL" object:currentUser.profilePicURL];
    }
    [backendUser setProperty:@"UUID" object:currentUser.UUID];
    
//    [backendless.userService registering:backendUser
//                    response:^(BackendlessUser *backUser){
//                        NSLog(@"User saved to backendless: %@",backUser);
//                    }
//                       error:^(Fault *fault){
//                           NSLog(@"ERROR User not saved to backendless Fault:%@", fault);
//                       }];
    Responder *responder = [Responder responder:self
                             selResponseHandler:@selector(responseHandler:)
                                selErrorHandler:@selector(errorHandler:)];
    [backendless.userService registering:backendUser responder:responder];
    
    
    return currentUser;
}

- (void)save {
    RLMRealm *currentUserRealm = [RLMRealm defaultRealm];
    [currentUserRealm beginWriteTransaction];
    [currentUserRealm deleteAllObjects];
    [currentUserRealm addObject:self];
    [currentUserRealm commitWriteTransaction];
}

-(id)responseHandler:(id)response {
    BackendlessUser *user = (BackendlessUser *)response;
    NSLog(@"user = %@", user);
    return user;
}

-(void)errorHandler:(Fault *)fault
{
    NSLog(@"FAULT = %@ <%@>", fault.message, fault.detail);
}

@end
