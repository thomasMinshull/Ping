//
//  UserManager.h
//  Ping
//
//  Created by thomas minshull on 2016-07-27.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PingUser.h"

@interface UserManager : NSObject

@property (strong, nonatomic)NSMutableSet *userList;
@property (strong, nonatomic)PingUser *currentUser; // may end up storing as realm user

+ (instancetype)sharedUserManager;

- (BOOL)previouslyLoggedIn; //check for UUID in UserDefaults, if not there return, else
- (void)loginAndCreateNewUserWithCompletion:(void(^)())completion; //Login with linked in, attempt to fetch User, add to backendless
- (void)createNewSessionWithoutNewUsersWithCompletion:(void(^)())completion;
- (PingUser *)userForUUID:(NSUUID *)uuid;
- (void)updateUserList;

@end

