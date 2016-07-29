//
//  UserRecord.m
//  Ping
//
//  Created by Martin Zhang on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "UserRecord.h"

@implementation UserRecord

- (instancetype)initWithUUID:(NSString *)uUID andDistance:(int)distance
{
    self = [super init];
    if (self) {
        _uUID = uUID;
        _totalDistance = distance;
        _numberOfObs = 1;
    }
    return self;
}

-(void)setTotalDistance:(int)totalDistance {
     // for some reason abs(totalDistance) was giving neg numbers ? 
    if (totalDistance <= 0) {
        _totalDistance = (-1)*totalDistance;
    } else {
        _totalDistance = totalDistance;
    }
}

@end
