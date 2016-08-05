//
//  CurrentUser.h
//  Ping
//
//  Created by thomas minshull on 2016-07-28.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "PingUser.h"

// CR: Why?
@interface CurrentUser : NSObject

@property (strong, nonatomic) PingUser *currentUser; 

@end
