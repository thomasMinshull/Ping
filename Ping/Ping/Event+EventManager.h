//
//  Event+EventManager.h
//  Ping
//
//  Created by Martin Zhang on 2016-08-08.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "Event.h"

@interface Event (EventManager)

-(RLMArray *)determineTimePeriodsCoveredByStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime;

@end
