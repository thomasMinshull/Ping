//
//  User.m
//  Ping
//
//  Created by thomas minshull on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "PingUser.h"
#import "NSString+UUID.h"

@implementation PingUser

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userUUID = [NSString getUUID];
    }
    return self;
}

- (void)setPropertiesWithProfileDictionary:(NSDictionary *)dic {
    self.lastName = dic[@"lastName"];
    self.firstName = dic[@"firstName"];
    self.headline = dic[@"headline"];
    self.linkedInID = dic[@"id"];
    
}

@end
