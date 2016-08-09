//
//  Event+EventManager.m
//  Ping
//
//  Created by Martin Zhang on 2016-08-08.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "Event+EventManager.h"

@implementation Event (EventManager)

-(RLMArray *)determineTimePeriodsCoveredByStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime {
    
//    [self.timePeriodsCovered addObjects: aTimePeriod];
    
    return self.timePeriodsCovered;
    
}

@end
