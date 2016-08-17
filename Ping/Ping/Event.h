//
//  Event.h
//  Ping
//
//  Created by Martin Zhang on 2016-08-08.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Realm/Realm.h>
#import "TimePeriod.h"

@interface Event : RLMObject

@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic) NSString *eventName;
@property (nonatomic) NSString *hostName;
@property (nonatomic) NSString *eventAddress; //
@property (strong) RLMArray<TimePeriod *><TimePeriod> *timePeriods;

@end

RLM_ARRAY_TYPE(Event)