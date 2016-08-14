//
//  BlueToothManager.h
//  Ping
//
//  Created by Jeff Eom on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BlueToothTestViewController.h" // temp for testing

@interface BlueToothManager : NSObject

@property (weak, nonatomic) BlueToothTestViewController *vc; //temp for testing

- (void)setUpBluetooth;
- (void)start;
- (void)stop;

@end
