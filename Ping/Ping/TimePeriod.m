//
//  TimePeriod.m
//  Ping
//
//  Created by Martin Zhang on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "TimePeriod.h"

@implementation TimePeriod

+ (RLMArray<TimePeriod *> *)sortArray:(RLMArray<TimePeriod *> *)array byDateAscending:(BOOL)ascending {

    RLMArray<TimePeriod *> *sortedArray;
    RLMResults<TimePeriod *> *results = [[array objectsWhere:@"startTime != nil" ] sortedResultsUsingProperty:@"startTime" ascending:ascending];
    
    for (TimePeriod *timePeriod in results) {
        [sortedArray addObject:timePeriod];
    }
    
    return sortedArray;
}

@end
