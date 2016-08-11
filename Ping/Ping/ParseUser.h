//
//  ParseUser.h
//  Ping
//
//  Created by thomas minshull on 2016-08-11.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Parse/Parse.h>

//Parse User is simply a clone of the User Classed used to pass objects to and from parse

@interface ParseUser : NSObject
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *headline;
@property (strong, nonatomic) NSString *linkedInID;
@property (strong, nonatomic) NSString *profilePicURL;
@property (strong, nonatomic) NSString *UUID;

@end
