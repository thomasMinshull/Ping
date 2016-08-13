//
//  BlueToothManager.h
//  Ping
//
//  Created by Jeff Eom on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlueToothManager : NSObject

- (void)updateUUIDList;
- (void)start;
- (void)stop;

@end
