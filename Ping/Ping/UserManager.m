//
//  UserManager.m
//  Ping
//
//  Created by thomas minshull on 2016-07-27.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "UserManager.h"
#import "CurrentUser.h"
#import "ParseUser.h"
#import <Parse/Parse.h>
#import "Ping-Swift.h"
#import "RecordManager.h"

@interface UserManager ()

//@property (nonatomic) BOOL temp;
@property (strong, nonatomic)NSMutableSet __block *parseUsers;
@end

@implementation UserManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    PFQuery *query = [PFQuery queryWithClassName:@"ParseUser"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error retreiving users from parse ERROR: %@", error);
        } else {
            self.parseUsers = [NSMutableSet new];
            NSMutableSet *users = [NSMutableSet new];
            
            for (PFObject *parseUser in objects) {
                [self.parseUsers addObject:parseUser];
                
                User *user = [self userFrom:parseUser];
                [users addObject:user];
            }
            RecordManager *recMan = [RecordManager new];
            [recMan backUpUsers:users];
        }
    }];
}

- (User *)userForUUID:(NSString *)uuid {
    
    for (PFObject *parseUser in self.parseUsers) {
        if ([parseUser[@"UUID"] isEqualToString:uuid]) {
            User *user =[self userFrom:parseUser];
            return user;
        }
    }
    return nil;
}

- (User *)userFrom:(PFObject *)parseUser {
    // copy parse user as regular user
    User *user = [[User alloc] init];
    user.firstName = parseUser[@"name"];
    user.lastName = parseUser[@"lastName"];
    user.headline = parseUser[@"headline"];
    user.linkedInID = parseUser[@"linkedInID"];
    user.UUID = parseUser[@"UUID"];
    user.profilePicURL = parseUser[@"profilePicURL"]; // should return empty string if null?
    return user;
}



@end
