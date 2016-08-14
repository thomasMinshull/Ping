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

- (User *)userForUUID:(NSString *)uuid;

- (void)fetchUsersWthCompletion:(void(^)(NSArray *users))completion;

@end

