//
//  PingUserRealm.m
//  Ping
//
//  Created by Martin Zhang on 2016-07-28.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "User.h"
#import "NSString+UUID.h"
#import "RecordManager.h"

@implementation User

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

// Realm objects do NOT support initializing.........................................................sadness

- (void)setPropertiesWithProfileDictionary:(NSDictionary *)dic {

    self.lastName = dic[@"lastName"];
    self.firstName = dic[@"firstName"];
    self.headline = dic[@"headline"];
    self.linkedInID = dic[@"id"];
    self.UUID = [NSString getUUID];
    
}

- (void)addProfilePic:(NSString *)profilePicURL {
    RecordManager *recordManager = [RecordManager new];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    dispatch_queue_t queue = recordManager.backgroundQueue;
    dispatch_async(queue, ^{
        [realm transactionWithBlock:^{
            self.profilePicURL = profilePicURL;
        }];
    });
}


@end
