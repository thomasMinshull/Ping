//
//  PingUserRealm.h
//  Ping
//
//  Created by Martin Zhang on 2016-07-28.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Realm/Realm.h>
#import "PingUser.h"

@interface User : RLMObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *headline;
@property (strong, nonatomic) NSString *linkedInID;
@property (strong, nonatomic) NSString *profilePicURL;
@property (strong, nonatomic) NSString *UUID;

- (void)setPropertiesWithProfileDictionary:(NSDictionary *)dic;
- (void)addProfilePic:(NSString *)profilePicURL; // realm doesn't support overwriting setters, just wraps setting in realm transaction

@end

RLM_ARRAY_TYPE(User)