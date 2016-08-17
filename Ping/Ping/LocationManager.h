//
//  LocationManager.h
//  Ping
//
//  Created by Jeff Eom on 2016-08-16.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

@import UIKit;
@import CoreLocation;

@protocol UserLocationManagerDelegate <NSObject>

-(void) newLocationDetected:(CLLocation*) location;

@end

@interface LocationManager : NSObject

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;

@property(nonatomic, weak) id<UserLocationManagerDelegate> delegate;

+ (id)sharedManager;
- (void)startLocationMonitoring;

/*
 -(void) initiateMap {
 self.locationManager = [MyLocationManager sharedManager];
 [self.locationManager startLocationMonitoring];
 self.locationManager.delegate = self;
 
 }
*/

@end
