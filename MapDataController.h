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

@property (weak, nonatomic) id delegate;

+ (instancetype)sharedInstance;

- (void) addLocationManagerDelegate:(id<LocationControllerDelegate>) delegate;
- (void) removelocationManagerDelegate:(id<LocationControllerDelegate>) delegate;

- (CLLocationCoordinate2D)getRandomizedSearchCircle:(CLLocation *)cacheLocation;

- (BOOL)canCompleteCache;

- (CLLocationDistance)getDistance:(CLLocation *)cacheLocation;

@end
