//
//  PingUserRealm.m
//  Ping
//
//  Created by Martin Zhang on 2016-07-28.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "PingUserRealm.h"

@implementation PingUserRealm

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

- (instancetype)initWithPingUserValue:(PingUser *)aPingUser
{
    self = [super init];
    if (self) {
        _firstName = aPingUser.firstName;
        _lastName = aPingUser.lastName;
        _headline = aPingUser.headline;
        _linkedInID = aPingUser.linkedInID;
        _profilePicURL = aPingUser.profilePicURL;
        _userUUID = aPingUser.userUUID;
    }
    return self;
}

@end
