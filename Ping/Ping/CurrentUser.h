//
//  currentUser.h
//  Ping
//
//  Created by thomas minshull on 2016-08-09.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "User.h"
#import "Event.h"

@interface CurrentUser : User

@property (strong) RLMArray<Event *><Event> *Events;

// ToDo add comment list

+ (CurrentUser *)makeCurrentUserWithProfileDictionary:(NSDictionary *)dic;
+ (CurrentUser *)getCurrentUser;
//- (void)save;

@end

RLM_ARRAY_TYPE(CurrentUser)