//
//  Comment.h
//  Ping
//
//  Created by Martin Zhang on 2016-08-08.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Realm/Realm.h>

@interface Comment : RLMObject

@property (nonatomic) NSString *targetUUID;
@property (nonatomic) NSString *content;

@end
