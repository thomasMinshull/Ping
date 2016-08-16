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
#import "NewEventViewController.h"
#import "LoginViewController.h"
#import "LoginManager.h"

#import <linkedin-sdk/LISDK.h>

#import <Parse/Parse.h>
#define Parse_APP_ID @"***REMOVED***"
#define Parse_Client_Key @"***REMOVED***"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIMutableUserNotificationAction *noBTAction = [[UIMutableUserNotificationAction alloc] init];
    noBTAction.identifier = @"NO_BLUETOOTH";
    noBTAction.title = @"Dismiss The Event";
    noBTAction.activationMode = UIUserNotificationActivationModeBackground;
    noBTAction.authenticationRequired = false;
    noBTAction.destructive = true;
    
    UIMutableUserNotificationAction *turnOnBTAction = [[UIMutableUserNotificationAction alloc] init];
    turnOnBTAction.identifier = @"YES_BLUETOOTH";
    turnOnBTAction.title = @"Turn on BlueTooth";
    turnOnBTAction.activationMode = UIUserNotificationActivationModeForeground;
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
    
//    // Configure welcome tutorial paging view down below:
   
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [self launchWelcomePagingViews];
    }
    return YES;
}    

- (void)applicationWillTerminate:(UIApplication *)application {
    //IntegrationManager *iM = [IntegrationManager sharedIntegrationManager];
    //   [iM.blueToothManager stop];
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
    
    BlueToothManager *btm = [BlueToothManager sharedBluetoothManager];
    
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

#pragma mark -3D Touch

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    NSLog(@"%@ item pressed.", shortcutItem.localizedTitle);
    
    LoginManager *loginManager = [[LoginManager alloc] init];
    
    if ([loginManager isLoggedIn]) {
        
        if ([shortcutItem.type isEqualToString:@"com.Ping.createEvent"]) {
            [self launchNewEventViewController];
        }
        
        if ([shortcutItem.type isEqualToString:@"com.Ping.surroundings"]) {
            [self launchSurroundingsViewController];
        }
        
        if ([shortcutItem.type isEqualToString:@"com.Ping.browseEvents"]) {
            [self launchEventCalenderViewController];
        }
    } else {
        // Launch Login screen to the sucker who wants to use app without logging in 😹
        [self launchLogInScreen];
    }
}

- (void)launchNewEventViewController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NewEventViewController *newEventVC = [storyboard instantiateViewControllerWithIdentifier:@"NewEventViewController"];
    
    self.window.rootViewController = newEventVC;
    [self.window makeKeyAndVisible];
    
}

- (void)launchEventCalenderViewController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    EventListViewController *eventListVC = [storyboard instantiateViewControllerWithIdentifier:@"EventListViewController"];
    
    self.window.rootViewController = eventListVC;
    [self.window makeKeyAndVisible];
    
}

- (void)launchSurroundingsViewController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CurrentSurroundingsViewController *surroundingVC = [storyboard instantiateViewControllerWithIdentifier:@"CurrentSurroundingsViewController"];
    
    self.window.rootViewController = surroundingVC;
    [self.window makeKeyAndVisible];
    
}

- (void)launchLogInScreen {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
}

#pragma mark -Intro paging tutorial

- (void)launchWelcomePagingViews {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    WelcomeScrollingViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"WelcomePagingViewController"];
    
    self.window.rootViewController = welcomeVC;
    
}

@end

