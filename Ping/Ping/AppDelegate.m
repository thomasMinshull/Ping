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
#import "Backendless.h"

#define APP_ID @"9D4CD068-86ED-EE23-FFA3-9BA9140C1800"
#define SECRET_KEY @"38C89559-F92A-B793-FF3C-CF09B6A31E00"
#define VERSION @"v1"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Backendless setup
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION];
    
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
