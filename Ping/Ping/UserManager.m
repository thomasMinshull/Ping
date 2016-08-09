//
//  UserManager.m
//  Ping
//
//  Created by thomas minshull on 2016-07-27.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "UserManager.h"
#import "PingUser.h"
#import "CurrentUser.h"
#import "Backendless.h"
#import "User.h"

#import "AppDelegate.h"
#import <linkedin-sdk/LISDK.h>
#define LINKEDIN_USER_URL @"https://api.linkedin.com/v1/people/~"
#define LINKEDIN_ADDITIONAL_INFO_URL @"https://api.linkedin.com/v1/people/~:(id,num-connections,picture-url)?format=json"

@interface UserManager ()

@property (nonatomic) BOOL temp;

@end

@implementation UserManager

+ (instancetype)sharedUserManager {
    static UserManager *sharedUserManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedUserManager = [[UserManager alloc] init];
        sharedUserManager.userList = [NSMutableSet new];
//        sharedUserManager.currentUser = [PingUser new];
//        sharedUserManager.temp = false;
    });
    
//    [sharedUserManager updateUserList];
    
    return sharedUserManager;
}

- (void)setUp {
    // get latest userList
    id<IDataStore> dataStore = [backendless.persistenceService of:[PingUser class]];
    
    @try {
        BackendlessCollection *backendlessUserListCollection = [dataStore find];
        // set page size to include the whole list of objects because backendless's pagination sucks!
        // ToDo fix pagination so it works properly
        [backendlessUserListCollection pageSize:[[backendlessUserListCollection getTotalObjects] integerValue]];
        
        NSArray *backendlessUserList = [backendlessUserListCollection getCurrentPage];
        
        NSMutableArray *uuidList = [NSMutableArray new];
        for (PingUser *u in backendlessUserList) {
            [self.userList addObject:u];
            [uuidList addObject:u.userUUID];
        }
        
        self.blueToothManager = [BlueToothManager sharedrecordManager:[uuidList copy] andCurrentUUID:[CurrentUser getCurrentUser].UUID];

    } @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
    }
}

- (PingUser *)userForUUID:(NSString *)uuid {
    
    for (PingUser *user in self.userList) {
        if ([user.userUUID isEqualToString:uuid]) {
            return user;
        }
    }
    return nil;
}

- (void)setProfilePicForUser:(User *)user WithCompletion:(void(^)())completion {
    [[LISDKAPIHelper sharedInstance] getRequest:LINKEDIN_ADDITIONAL_INFO_URL success:^(LISDKAPIResponse *response) {
        NSLog(@"successfully retrieved profile pic with response: %@", response.data);
        
        NSData *profilePicResponse = [response.data dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *picError;
        NSDictionary *myPic = [NSJSONSerialization JSONObjectWithData:profilePicResponse
                                                              options:NSJSONReadingMutableContainers
                                                                error:&picError];
        NSString *picURl = myPic[@"pictureUrl"];
        
        [user addProfilePic:picURl];
        
        completion();
    
    } error:^(LISDKAPIError *error) {
        NSLog(@"Error when loading profile Pic: %@", error);
        completion();
    }];
}

#pragma mark - Backendless Methods

- (void)saveBackendlessUser:(PingUser *)user {
    id<IDataStore> dataStore = [backendless.persistenceService of:[PingUser class]];
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [dataStore save:user];
             });
    
    Fault *fault;
    BackendlessCollection *collection = [dataStore findFault:&fault];
    NSLog(@"log global list of users: %@", collection);
}

- (void)stopScanning {
    [self.blueToothManager stop];
}

@end
