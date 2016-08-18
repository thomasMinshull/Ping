//
//  LoginManager.m
//  Ping
//
//  Created by thomas minshull on 2016-08-08.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "LoginManager.h"
#import "UserManager.h"
#import "RecordManager.h"
#import "CurrentUser.h"
#import "User.h"
#import <linkedin-sdk/LISDK.h>
#import "Ping-Swift.h"

#define LINKEDIN_USER_URL @"https://api.linkedin.com/v1/people/~"
#define LINKEDIN_ADDITIONAL_INFO_URL @"https://api.linkedin.com/v1/people/~:(id,num-connections,picture-url)?format=json"


@implementation LoginManager

- (BOOL)isFirstTimeUser {
    if ([CurrentUser getCurrentUser]) {
        return false;
    } else {
        return true;
    }
}

- (BOOL)isLoggedIn {
    if ([LISDKSessionManager hasValidSession] ) {
        return true;
    } else {
        return false;
    }
}

- (void)attemptToLoginWithCompletion:(void(^)(BOOL))completion {
    [LISDKSessionManager createSessionWithAuth:@[LISDK_BASIC_PROFILE_PERMISSION]
                                         state:@"loginWithExistingToken"
                        showGoToAppStoreDialog:YES
                                  successBlock:^(NSString *state) {
        completion(true);
    
    } errorBlock:^(NSError *error) {
        NSLog(@"Error when logging in with LinkedIn %@", error);
        completion(false);
        
    }];
}

- (void)createNewUserAndLoginWithCompletion:(void(^)(BOOL))completion {
    [LISDKSessionManager createSessionWithAuth:@[LISDK_BASIC_PROFILE_PERMISSION]
                                         state:@"login with button"
                        showGoToAppStoreDialog:YES
                                  successBlock:^(NSString *state) {;

        [self createUserWithCompletion:completion];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Error when logging in with LinkedIn %@", error);
        completion(NO);
    }];
}

- (void)createUserWithCompletion:(void(^)(BOOL))completion {
    
    [[LISDKAPIHelper sharedInstance] getRequest:LINKEDIN_USER_URL
                                        success:^(LISDKAPIResponse *response) {
                                            NSLog(@"got user profile: %@", response.data);
                                            
                                            NSData *data = [response.data dataUsingEncoding:NSUTF8StringEncoding];
                                            
                                            NSError *error;
                                            
                                            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                            
                                            if (![CurrentUser getCurrentUser]) {
                                                [CurrentUser makeCurrentUserWithProfileDictionary:json];
                                            }
                                            
                                            [self updateUsersProfilePic];
                                            
                                            completion(true);
                                        }
                                          error:^(LISDKAPIError *apiError) {
                                              // do something with error
                                              NSLog(@"Failed to get user profile: %@", apiError);
                                              
                                              completion(false);
                                          }];
}



- (void)updateUsersProfilePic {
    [[LISDKAPIHelper sharedInstance] getRequest:LINKEDIN_ADDITIONAL_INFO_URL success:^(LISDKAPIResponse *response) {
        NSLog(@"successfully retrieved profile pic with response: %@", response.data);
        
        NSData *profilePicResponse = [response.data dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *picError;
        NSDictionary *myPic = [NSJSONSerialization JSONObjectWithData:profilePicResponse
                                                              options:NSJSONReadingMutableContainers
                                                                error:&picError];
        NSString *picURL = myPic[@"pictureUrl"];
        
        UserManager *userMan = [[UserManager alloc] init];
        [userMan addProfilePic:picURL];
        
        
        
    } error:^(LISDKAPIError *error) {
        NSLog(@"Error when loading profile Pic: %@", error);
    }];
}

@end
