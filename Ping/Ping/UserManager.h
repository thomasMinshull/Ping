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

- (void)attemptToLoginWithPreviousToken; //check for UUID in UserDefaults, if not there return, else
- (void)loginAndCreateNewUser; //Login with linked in, attempt to fetch User, add to backendless
- (PingUser *)userForUUID:(NSUUID *)uuid;
- (void)updateUserList;

@end
