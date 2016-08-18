//
//  TimePeriod.h
//  Ping
//
//  Created by Martin Zhang on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Realm/Realm.h>
#import "UserRecord.h"


@interface TimePeriod : RLMObject

@property (atomic) NSDate *startTime;
@property (atomic) RLMArray<UserRecord *><UserRecord> *userRecords;

+ (NSArray *)sortArray:(RLMArray<TimePeriod *> *)array byDateAscending:(BOOL)ascending;

@end

RLM_ARRAY_TYPE(TimePeriod)