//
//  LoginManager.m
//  Ping
//
//  Created by thomas minshull on 2016-08-08.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "LoginManager.h"
#import "PingUserRealm.h"
#import <linkedin-sdk/LISDK.h>

#define LINKEDIN_USER_URL @"https://api.linkedin.com/v1/people/~"
#define LINKEDIN_ADDITIONAL_INFO_URL @"https://api.linkedin.com/v1/people/~:(id,num-connections,picture-url)?format=json"

//will need to be deleted once we have current user cleaned up
#import "UserManager.h"
#import "AppDelegate.h"

@interface LoginManager ()

@property (nonatomic) RLMRealm *currentRealmUser; // should be getting this from realm

@end

@implementation LoginManager

- (BOOL)isFirstTimeUser {
    if ([self.currentRealmUser isEmpty]) {
        return false;
    } else {
        return true;
    }
}

- (BOOL)isLoggedIn {
    if (![self.currentRealmUser isEmpty] && [UserManager sharedUserManager].fetchCurrentUserFromRealm.userUUID ) { // need to just get current user and check the UUID directly
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
                                            
                                            PingUser *selfUser = [self createUserWithResponseString:response.data];
                                            NSLog(@"self user uuid: %@", selfUser.userUUID);
                                            
                                            
                                            // ToDo store current user in realm
                                            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                            
                                            app.currentUser = selfUser;
                                            
                                            // Add Profile Pic
                                            
                                            __weak UserManager *um = [UserManager sharedUserManager];
                                            [um setProfilePicForUser:selfUser WithCompletion:^{
                                                
                                                [um saveBackendlessUser:selfUser];
                                                // save to realm as current user
                                                [um persistCurrentUserToRealm:selfUser];
                                            }];
                                            
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
