//
//  BlueToothController.h
//  Ping
//
//  Created by Jeff Eom on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TransferService.h"

@interface BlueToothController : NSObject

@property NSMutableArray *uuids;
@property NSMutableArray *distances;
@property NSMutableArray *timeStamps;

@end
