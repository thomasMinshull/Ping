//
//  AverageUUidDuple.h
//  Ping
//
//  Created by thomas minshull on 2016-07-29.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Foundation/Foundation.h>


// CR: "Duple" not a data structure. Better names: "AveragedUUID", "UUIDAverage", "AveragedScore", "Score", "Distance" etc. (ideally exclude types from the class name).

@interface AverageUUidDuple : NSObject

@property int userAverage;
@property (strong, nonatomic) NSString *uUID;


@end
