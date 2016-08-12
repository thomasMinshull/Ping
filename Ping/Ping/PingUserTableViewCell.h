//
//  PingUserTableViewCell.h
//  Ping
//
//  Created by thomas minshull on 2016-07-27.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface PingUserTableViewCell : UITableViewCell

- (void)setUpWithUser:(User *)user;

@end
