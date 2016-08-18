//
//  TimePeriod.m
//  Ping
//
//  Created by Martin Zhang on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "TimePeriod.h"

@implementation TimePeriod

+ (NSArray *)sortArray:(RLMArray<TimePeriod *> *)array byDateAscending:(BOOL)ascending {

    NSMutableArray *sortArray = [[NSMutableArray alloc] init];
    RLMResults<TimePeriod *> *results = [[array objectsWhere:@"startTime != nil" ] sortedResultsUsingProperty:@"startTime" ascending:ascending];
    
    for (TimePeriod *timePeriod in results) {
        [sortArray addObject:timePeriod];
    }
    return [sortArray copy];
}

@end
