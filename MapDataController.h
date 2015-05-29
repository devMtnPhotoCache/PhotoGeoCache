//
//  MapDataController.h
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface MapDataController : NSObject

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, readonly) CLLocationDegrees *cacheLocationLatitude;
@property (nonatomic, readonly) CLLocationDegrees *cacheLocationLongitude;

+ (instancetype)sharedInstance;

- (CLLocationCoordinate2D)getRandomizedSearchCircle:(CLLocation *)cacheLocation;

@end
