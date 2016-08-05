//
//  AppDelegate.h
//  Ping
//
//  Created by thomas minshull on 2016-07-24.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

//CR: - Two warnings ("treat warnings as errors")

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "PingUser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// CR: Realm and core data?? Tear this out!
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// CR: why?
@property (strong, nonatomic) PingUser *currentUser;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

