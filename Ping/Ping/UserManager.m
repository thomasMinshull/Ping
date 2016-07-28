//
//  UserManager.m
//  Ping
//
//  Created by thomas minshull on 2016-07-27.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "UserManager.h"
#import <linkedin-sdk/LISDK.h>
#import "PingUser.h"
#import "Backendless.h"

#define LINKEDIN_USER_URL @"https://api.linkedin.com/v1/people/~"
#define LINKEDIN_ADDITIONAL_INFO_URL @"https://api.linkedin.com/v1/people/~:(id,num-connections,picture-url)?format=json"

@implementation UserManager

- (void)attemptToLoginWithPreviousToken {
    //query keychain
    
    NSMutableDictionary *query = [@{
                                    (__bridge id)kSecReturnAttributes : (__bridge id)kCFBooleanTrue,
                                    (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitAll,
                                    (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                    (__bridge id)kSecReturnData : (__bridge  id)kCFBooleanTrue
                                    } mutableCopy];
    
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    NSLog(@"%@", (__bridge id)result);
    
    if (result != NULL) { // We found the key, maybe we should check it
        
        // Nahh never mind :P
        [self createNewSessionWithoutNewUsers];
    }
    
    /* ToDo Unfinished Code used to validate the key and create new session 
     NSArray *resultArray = (__bridge_transfer NSArray *)result;
     NSDictionary *resultDict = [resultArray firstObject];
     NSData *pswd = resultDict[(__bridge id)kSecValueData];
     NSString *password = [[NSString alloc] initWithData:pswd encoding:NSUTF16StringEncoding];
     
     NSLog(@"serialized token: %@", password);
     //CFRelease(result);
     
     
     [LISDKSessionManager createSessionWithAccessToken:[LISDKAccessToken LISDKAccessTokenWithSerializedString:password]];
     
     [self createNewSession];
     
     NSLog(@"ACcess tokens %@ ::::: %@",[[LISDKSessionManager sharedInstance].session.accessToken serializedString], password);
     */
}

- (void)createNewSessionWithoutNewUsers {
    [LISDKSessionManager createSessionWithAuth:@[LISDK_BASIC_PROFILE_PERMISSION] state:@"login with button" showGoToAppStoreDialog:YES successBlock:^(NSString *state) {
        NSLog(@"Success Segue to new screen");
    } errorBlock:^(NSError *error) {
        NSLog(@"Error when logging in with LinkedIn %@", error);
        
        //ToDo display error message to user
        
    }];
}


- (void)createUser {

    if ([LISDKSessionManager hasValidSession]) {// double check that we are logged in
        // get profile
        [[LISDKAPIHelper sharedInstance] getRequest:LINKEDIN_USER_URL
                                            success:^(LISDKAPIResponse *response) {
                                                NSLog(@"got user profile: %@", response.data);
                                                
                                                PingUser *selfUser = [self createUserWithResponseString:response.data];
                                                
                                                // Add Profile Pic
                                                
                                                __weak UserManager *weakSelf = self;
                                                [self setProfilePicForUser:selfUser WithCompletion:^{
                                                    [weakSelf saveBackendlessUser:selfUser];
                                                }];
                                                
                                            }
                                              error:^(LISDKAPIError *apiError) {
                                                  // do something with error
                                                  NSLog(@"Failed to get user profile: %@", apiError);
                                                  
                                                  //ToDo display error
                                              }];
    }
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

- (void)setProfilePicForUser:(PingUser *)user WithCompletion:(void(^)())completion {
    [[LISDKAPIHelper sharedInstance] getRequest:LINKEDIN_ADDITIONAL_INFO_URL success:^(LISDKAPIResponse *response) {
        NSLog(@"successfully retrieved profile pic with response: %@", response.data);
        
        NSData *profilePicResponse = [response.data dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *picError;
        NSDictionary *myPic = [NSJSONSerialization JSONObjectWithData:profilePicResponse
                                                              options:NSJSONReadingMutableContainers
                                                                error:&picError];
        NSString *picURl = myPic[@"pictureUrl"];
        
        user.profilePicURL = picURl;
    
    } error:^(LISDKAPIError *error) {
        NSLog(@"Error when loading profile Pic: %@", error);
        
    }];
}


- (void)saveBackendlessUser:(PingUser *)user {
    id<IDataStore> dataStore = [backendless.persistenceService of:[PingUser class]];
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [dataStore save:user];
             });
    
    Fault *fault;
    BackendlessCollection *collection = [dataStore findFault:&fault];
    NSLog(@"log global list of users: %@", collection);
}

//- (void)createNewBackendlessUserWithUser:(User *)user {

//    BackendlessUser *backendUser = [BackendlessUser new];
//    [backendUser setProperty:@"UID" object:user.userUUID];
//    backendUser.password = user.linkedInID;

//    [backendless.userService registering:backendUser
//                                response:^(BackendlessUser *backendUser) {
//                                    NSLog(@"User Registered");
//                                } error:^(Fault *fault) {
//                                    NSLog(@"Fault: %@", fault);
//                                }];
//}


/*[[LISDKDeeplinkHelper sharedInstance] viewOtherProfile:martinID withState:@"viewMemberProfileButton" showGoToAppStoreDialog:NO success:success error:error];
 */


- (void)loginAndCreateNewUser{
    [LISDKSessionManager createSessionWithAuth:@[LISDK_BASIC_PROFILE_PERMISSION] state:@"login with button" showGoToAppStoreDialog:YES successBlock:^(NSString *state) {
        NSLog(@"Success Segue to new screen");
        
        // am I a new user? check realm for currentUser
        
        // if currentUser does not exist in realm
        [self createUser];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Error when logging in with LinkedIn %@", error);
        
        //ToDo display error message to user
        
    }];
}

- (PingUser *)userForUUID:(NSUUID *)uuid {
    return nil;
}

- (void)updateUserList {
    // get latest userList
    id<IDataStore> dataStore = [backendless.persistenceService of:[PingUser class]];
    
    @try {
        BackendlessCollection *backendlessUserListCollection = [dataStore find];
        NSArray *backendlessUserList = [backendlessUserListCollection getCurrentPage];
        self.userList = [NSMutableSet new];
        
        for (PingUser *u in backendlessUserList) { // will work for first 100 users
            [self.userList addObject:u];
        }
        
        //ToDo deal with getting multiple pages and adding all users to self.userList
        
    } @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
    }
}

- (void)updateProfilePicForUser:(PingUser *)user {
    [self setProfilePicForUser:user WithCompletion:nil];
    
}

#pragma mark -Convience Methods

- (void)realmUserFromBackendlessUser:(PingUser *)backendlessUser {
    
}

//- (BOOL)isUserListUpToDate {
//    return true;
//}

//- (BOOL)profilePicExistesForUser:(PingUser *)user {
//    return NO;
//}


@end
