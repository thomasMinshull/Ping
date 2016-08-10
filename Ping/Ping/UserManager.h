//
//  UserManager.h
//  Ping
//
//  Created by thomas minshull on 2016-07-27.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <Realm/Realm.h>
#import "BlueToothManager.h"

@interface UserManager : NSObject

@property (strong, nonatomic) NSMutableArray *uuids;

- (void)setProfilePicForUser:(User *)user WithCompletion:(void(^)())completion;

- (void)saveBackendlessUser:(User *)user; // this is only ever used to save current user, may want to refactor to reflect this?

- (User *)userForUUID:(NSString *)uuid;
- (void)updateUserList;

// refactor into integration manager
- (void)setUp;

@end

