//
//  UserRecord.h
//  Ping
//
//  Created by Martin Zhang on 2016-07-26.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserRecord : RLMObject

@property (nonatomic) NSString *UUID;
@property (nonatomic) int totalDistance;
@property (nonatomic) int numberOfObs;
@property (nonatomic) int userAverage; // ToDo Refactor: move this to be a calculated property in an category n

- (instancetype)initWithUUID:(NSString *)uUID andDistance:(int)distance;

@end

RLM_ARRAY_TYPE(UserRecord)