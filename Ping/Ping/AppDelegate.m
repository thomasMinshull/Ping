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
#import "BlueToothManager.h"

#import <linkedin-sdk/LISDK.h>

#import <Parse/Parse.h>
#define Parse_APP_ID @"***REMOVED***"
#define Parse_Client_Key @"***REMOVED***"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIMutableUserNotificationAction *noBTAction = [[UIMutableUserNotificationAction alloc] init];
    noBTAction.identifier = @"NO_BLUETOOTH";
    noBTAction.title = @"Do not turn it on";
    noBTAction.activationMode = UIUserNotificationActivationModeBackground;
    noBTAction.authenticationRequired = false;
    noBTAction.destructive = true;
    
    UIMutableUserNotificationAction *turnOnBTAction = [[UIMutableUserNotificationAction alloc] init];
    turnOnBTAction.identifier = @"YES_BLUETOOTH";
    turnOnBTAction.title = @"Turn on BlueTooth";
    turnOnBTAction.activationMode = UIUserNotificationActivationModeBackground;
    turnOnBTAction.authenticationRequired = false;
    turnOnBTAction.destructive = false;
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"BT_CATEGORY";
    [category setActions:@[noBTAction, turnOnBTAction] forContext: UIUserNotificationActionContextDefault];
    [category setActions:@[noBTAction, turnOnBTAction] forContext: UIUserNotificationActionContextMinimal];
    
    
    // Ask for notification permission.
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:[NSSet setWithObject: category]]];
        
        [application registerForRemoteNotifications];
    }
    
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

#pragma mark - Action upon notification

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    int caseNum;
    BlueToothManager *btm = [[BlueToothManager alloc] init];
    
    if ([identifier isEqualToString: @"YES_BLUETOOTH"]){
        caseNum = 0;
    }else if ([identifier isEqualToString: @"NO_BLUETOOTH"]){
        caseNum = 1;
    }
    
    switch (caseNum) {
        case 0:
            [btm start];
            NSLog(@"bluetooth is on!");
            break;
        case 1:
            [btm stop];
            NSLog(@"bluetooth is off!");
            break;
    }
    completionHandler();
}

@end
