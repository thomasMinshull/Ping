//
//  RecordManager.h
//  Ping
//
//  Created by Martin Zhang on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimePeriod.h"
#import "UserRecord.h"

@interface RecordManager : NSObject

@property (strong, nonatomic) dispatch_queue_t backgroundQueue;

- (void)storeBlueToothDataByUUID:(NSString *)userUUID userProximity:(int)proximity andTime:(NSDate *)time;
- (NSMutableArray *)sortingUserRecordsInTimePeriodByProximity:(NSDate *)date;
- (NSDate *)getStartTimeForTimePeriod:(NSDate *)time;
- (void)backUpUsers:(NSMutableArray *)users;
- (NSArray *)uuidList;

@end
