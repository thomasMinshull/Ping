//
//  BlueToothManager.h
//  Ping
//
//  Created by Jeff Eom on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TransferService.h"

@interface BlueToothManager : NSObject

@property NSArray *uuidList;
@property NSString *currentUserUUID;
//@property RecordManager *recordManager;
@property NSMutableArray *bluetoothData;

- (void)start;
- (void)stop;

- (instancetype)initWithUUIDList:(NSArray *)uuidList andCurrentUUID:(NSString *)currentUUID;

- (void)sendInBluetoothData;

@end
