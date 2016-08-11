//
//  AppDelegate.m
//  Ping
//
//  Created by thomas minshull on 2016-07-24.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "AppDelegate.h"
#import "Ping-Bridging-Header.h"
#import "UserManager.h"
#import "Ping-Swift.h"

#import <linkedin-sdk/LISDK.h>

#import <Parse/Parse.h>
#define Parse_APP_ID @"QaDwdtxkrP8gd42kZrvn1aHv64PKRNLxuuHY964v"
#define Parse_Client_Key @"AZ8btrgurhLG306dVeWjKjx9nSszPI5sAoqwcZ6F"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialize Parse.
    [Parse setApplicationId:Parse_APP_ID clientKey:Parse_Client_Key];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
IntegrationManager *iM = [IntegrationManager sharedIntegrationManager];
   [iM.blueToothManager stop];
}

#pragma mark -LinkedIn SDK
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([LISDKCallbackHandler shouldHandleUrl:url]) {
        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return YES;
}

@end
