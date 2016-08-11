//
//  LoginManager.h
//  Ping
//
//  Created by thomas minshull on 2016-08-08.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

- (BOOL)isFirstTimeUser;
- (BOOL)isLoggedIn;
- (void)attemptToLoginWithCompletion:(void(^)(BOOL))completion;
- (void)createNewUserAndLoginWithCompletion:(void(^)(BOOL))completion;

@end
