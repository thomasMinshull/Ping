//
//  LoginManager.m
//  Ping
//
//  Created by thomas minshull on 2016-08-08.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "LoginManager.h"
#import "UserManager.h"
#import "CurrentUser.h"
#import "User.h"
#import <linkedin-sdk/LISDK.h>
#import "Ping-Swift.h"

#define LINKEDIN_USER_URL @"https://api.linkedin.com/v1/people/~"
#define LINKEDIN_ADDITIONAL_INFO_URL @"https://api.linkedin.com/v1/people/~:(id,num-connections,picture-url)?format=json"


@interface LoginManager ()

@property (weak, nonatomic) IntegrationManager *iM;

@end

@implementation LoginManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.iM = [IntegrationManager sharedIntegrationManager];
    }
    return self;
}

- (BOOL)isFirstTimeUser {
    if ([CurrentUser getCurrentUser]) {
        return false;
    } else {
        return true;
    }
}

- (BOOL)isLoggedIn {
    CurrentUser *currentUser = [CurrentUser getCurrentUser];
    if (!currentUser && currentUser.UUID ) {
        // need to just get current user and check the UUID directly
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
        
        // ToDo am I a new user? my LinkedIn ID against a list of LinkedIn Id's
        
        // if currentUser does not exist in realm
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
                                            
                                            NSData *responseData = [(NSString *)response dataUsingEncoding:NSUTF8StringEncoding];
                                            
                                            NSError *jsonError;
                                            
                                            NSDictionary *currentProfile = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                                      options:NSJSONReadingMutableContainers
                                                                                                        error:&jsonError];
                                            
                                            CurrentUser *currentUser;
                                            @synchronized (self) {// make sure we can't create duplicate users
                                                if (![CurrentUser getCurrentUser] && !jsonError) {
                                                    currentUser = [CurrentUser makeCurrentUserWithProfileDictionary:currentProfile];
                                                }
                                            }
                                            NSLog(@"self user uuid: %@", currentUser.UUID);
                                            
                                            // Add Profile Pic
                                            [self.iM.userManager setProfilePicForUser:currentUser WithCompletion:nil];
                                            
                                            completion(true);
                                        }
                                          error:^(LISDKAPIError *apiError) {
                                              // do something with error
                                              NSLog(@"Failed to get user profile: %@", apiError);
                                              
                                              completion(false);
                                          }];
}

- (PingUser *)createUserWithResponseString:(NSString *)response {
    NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    NSDictionary *myProfile = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&jsonError];
    
    PingUser *selfUser = [[PingUser alloc] init];
    [selfUser setPropertiesWithProfileDictionary:myProfile];
    
    return selfUser;
}



@end
