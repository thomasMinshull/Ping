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
#import "BlueToothManager.h"

#define LINKEDIN_USER_URL @"https://api.linkedin.com/v1/people/~"
#define LINKEDIN_ADDITIONAL_INFO_URL @"https://api.linkedin.com/v1/people/~:(id,num-connections,picture-url)?format=json"

@interface UserManager ()

@property (strong, nonatomic) BlueToothManager *blueToothManager;

@end

@implementation UserManager

+ (instancetype)sharedUserManager {
    static UserManager *sharedUserManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedUserManager = [[UserManager alloc] init];
        sharedUserManager.userList = [NSMutableSet new];
        sharedUserManager.currentUser = [PingUser new];
    });
    
    [sharedUserManager updateUserList];
    
    return sharedUserManager;
}



- (PingUser *)userForUUID:(NSString *)uuid {
    // ToDo implement
    
    return nil;
}

- (void)updateUserList {
    // get latest userList
    id<IDataStore> dataStore = [backendless.persistenceService of:[PingUser class]];
    
    @try {
        BackendlessCollection *backendlessUserListCollection = [dataStore find];
        // set page size to include the whole list of objects because backendless's pagination sucks!
        // ToDo fix pagination so it works properly
        [backendlessUserListCollection pageSize:[[backendlessUserListCollection getTotalObjects] integerValue]];
        
        NSArray *backendlessUserList = [backendlessUserListCollection getCurrentPage];
        self.userList = [NSMutableSet new];
        
        NSMutableArray *uuidList = [NSMutableArray new];
        for (PingUser *u in backendlessUserList) {
            [self.userList addObject:u];
            [uuidList addObject:u.userUUID];
        }
        
            self.blueToothManager = [BlueToothManager sharedrecordManager:[uuidList copy] andCurrentUUID:self.currentUser.userUUID];
        
    } @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
    }
    
    [self.blueToothManager start];
}

- (void)updateProfilePicForUser:(PingUser *)user {
    [self setProfilePicForUser:user WithCompletion:nil];
    
}


#pragma  mark -Loggin Methods 

- (BOOL)previouslyLoggedIn {
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
        return YES; // Nahh never mind :P
        
//              [self createNewSessionWithoutNewUsers];
    }
    return NO;
    
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

- (void)createNewSessionWithoutNewUsersWithCompletion:(void(^)())completion {
    [LISDKSessionManager createSessionWithAuth:@[LISDK_BASIC_PROFILE_PERMISSION] state:@"login with button" showGoToAppStoreDialog:YES successBlock:^(NSString *state) {
        NSLog(@"Success Segue to new screen");
        completion();
    } errorBlock:^(NSError *error) {
        NSLog(@"Error when logging in with LinkedIn %@", error);
        //ToDo display error message to user
        
    }];
}


- (void)createUserWithCompletion:(void(^)())completion {

    if ([LISDKSessionManager hasValidSession]) {// double check that we are logged in
        // get profile
        [[LISDKAPIHelper sharedInstance] getRequest:LINKEDIN_USER_URL
                                            success:^(LISDKAPIResponse *response) {
                                                NSLog(@"got user profile: %@", response.data);
                                                
                                                PingUser *selfUser = [self createUserWithResponseString:response.data];
                                                
                                                self.currentUser = selfUser;
                                                // Add Profile Pic
                                                
                                                __weak UserManager *weakSelf = self;
                                                [self setProfilePicForUser:selfUser WithCompletion:^{
                                                    [weakSelf saveBackendlessUser:selfUser];
                                                    completion();
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


- (void)loginAndCreateNewUserWithCompletion:(void(^)())completion{
    [LISDKSessionManager createSessionWithAuth:@[LISDK_BASIC_PROFILE_PERMISSION] state:@"login with button" showGoToAppStoreDialog:YES successBlock:^(NSString *state) {
        NSLog(@"Success Segue to new screen");
        
        // ToDo am I a new user? check realm for currentUser
        
        
        // if currentUser does not exist in realm
        [self createUserWithCompletion:completion];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Error when logging in with LinkedIn %@", error);
        
        //ToDo display error message to user
        
    }];
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
