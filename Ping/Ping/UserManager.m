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
            self.uuids = [NSMutableArray new];
            
            for (PFObject *parseUser in objects) {
                
                [self.parseUsers addObject:parseUser];
                [self.uuids addObject:[parseUser objectForKey:@"UUID"]];
            }
        }
        
    }];
    
//        User *user1 = [User new];
//        user1.firstName = @"Martin";
//        user1.lastName = @"Zhang";
//        user1.headline = @"stuff";
//        user1.linkedInID = @"stuff";
//        user1.profilePicURL = @"https://media.licdn.com/mpr/mprx/0_toKw915dIk5rEJF8OU6IYKyHoARu2R5ygUeLKQodo1eD2INKgU6w41kdDkBD2Ib3YUEQ4FFWF1eS7xzKjMvBOF65C1e270r2RMvez61eW-g85dIKBHi6vtjMGQtp60bjtVAbtqut7mP";
//        
//        
//        self.uuids = [@[@"FEBAA2DD-CE1A-4125-96D0-097DFD047E83", @"0D623438-99D7-4B39-B6BB-03936A6B379B",@"C826D6CF-E64B-4159-8B6F-FCE60C18C12D",@"71C12256-AFE6-4D3D-9E5A-1B0E6ED0CB8F",@"19A86001-A1B4-44DE-879B-F9FD6B7D945F",@"84241393-5155-4307-B5F6-38C013447E02",@"FB2165CD-B0FF-4F96-87AB-C9BC6C3851BE",@"8E88F0CC-C79F-46E8-B323-C06DB3ED32E5"] mutableCopy];

 
}

- (User *)userForUUID:(NSString *)uuid {
    
    for (PFObject *parseUser in self.parseUsers) {
        if ([parseUser[@"UUID"] isEqualToString:uuid]) {
            
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
    }
    return nil;
}

@end
