//
//  PingUserRealm.h
//  Ping
//
//  Created by Martin Zhang on 2016-07-28.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Realm/Realm.h>
#import "PingUser.h"

@interface PingUserRealm : RLMObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *headline;
@property (strong, nonatomic) NSString *linkedInID;
@property (strong, nonatomic) NSString *profilePicURL;
//@property (strong, nonatomic) NSDictionary *profileRequest;

@property (strong, nonatomic) NSString *userUUID;

- (instancetype)initWithPingUserValue:(PingUser *)aPingUser;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<PingUserRealm>
RLM_ARRAY_TYPE(PingUserRealm)
