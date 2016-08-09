//
//  currentUser.h
//  Ping
//
//  Created by thomas minshull on 2016-08-09.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "User.h"

@interface CurrentUser : User

// ToDo add comment list

+ (CurrentUser *)makeCurrentUserWithProfileDictionary:(NSDictionary *)dic;
+ (CurrentUser *)getCurrentUser;
- (void)setCurrentUserProfilePic:(NSString *)profilePicURL;
- (void)save;

@end

RLM_ARRAY_TYPE(CurrentUser)