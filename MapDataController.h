//
//  MapDataController.h
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationControllerDelegate

- (void)locationControllerDidUpdateLocation:(CLLocation *)location;

@end

@interface MapDataController : NSObject <LocationControllerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, readonly) CLLocationDegrees *cacheLocationLatitude;
@property (nonatomic, readonly) CLLocationDegrees *cacheLocationLongitude;
@property (nonatomic, assign) CLLocation *currentUserLocation;
@property (nonatomic, strong) CLLocation *location;

+ (instancetype)sharedInstance;

- (void)start;

// GUYS! THIS SHOULD BE AN NSNOTIFICATION NOT A DELEGATE ARRAY SILLY BOYS
// If you just subscribe to notification keys, you can post when the location changes
// Then anyone that cares, can see the notification and respond by asking the map controller for
// the current location

- (void) addLocationManagerDelegate:(id<LocationControllerDelegate>) delegate;
- (void) removelocationManagerDelegate:(id<LocationControllerDelegate>) delegate;

- (CLLocation *)getRandomizedSearchCircle:(CLLocation *)cacheLocation;

- (BOOL)canCompleteCache;

- (CLLocationDistance)getDistance:(CLLocation *)cacheLocation;

@end
