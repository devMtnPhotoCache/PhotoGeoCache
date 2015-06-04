//
//  MapDataController.h
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationControllerDelegate <NSObject>

- (void)locationControllerDidUpdateLocation:(CLLocation *)location;

@end

@interface MapDataController : NSObject

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, readonly) CLLocationDegrees *cacheLocationLatitude;
@property (nonatomic, readonly) CLLocationDegrees *cacheLocationLongitude;
@property (nonatomic, strong) CLLocation *location;

@property (weak, nonatomic) id delegate;

+ (instancetype)sharedInstance;

- (CLLocationCoordinate2D)getRandomizedSearchCircle:(CLLocation *)cacheLocation;

- (BOOL)canCompleteCache;

- (CLLocationDistance)getDistance:(CLLocation *)cacheLocation;

@end
