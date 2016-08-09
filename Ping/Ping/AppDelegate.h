//
//  AppDelegate.h
//  Ping
//
//  Created by thomas minshull on 2016-07-24.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "PingUser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PingUser *currentUser;

@end

