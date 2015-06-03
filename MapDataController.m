//
//  MapDataController.m
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#define METERS_MILE 1609.344
#define METERS_FEET 3.28084
#define ARC4RANDOM_MAX 0x100

#import "MapDataController.h"
#import "ViewController.h"
#import "CacheModel.h"
@import UIKit;

@interface MapDataController () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationDegrees *randomizedCacheLocationLatitude;
@property (nonatomic) CLLocationDegrees *randomizedCacheLocationLongitude;
@property (nonatomic) CLLocation *cacheLocation;
@property (nonatomic) CLLocation *currentUserLocation;

@end

@implementation MapDataController

+ (instancetype)sharedInstance
{
    static MapDataController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MapDataController alloc] init];
        
        sharedInstance.locationManager = [[CLLocationManager alloc] init];
        
        [sharedInstance.locationManager setDelegate:sharedInstance];
        
        CacheModel *currentCache = [CacheModel new];
        
        sharedInstance.cacheLocation = currentCache.cacheLocation;
        
        
        
#pragma - Location Manager Setup
        
        if ([sharedInstance.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [sharedInstance.locationManager requestWhenInUseAuthorization];
        }
        
        [sharedInstance.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [sharedInstance.locationManager startUpdatingLocation];
        
    });
    
    return sharedInstance;
}


//Currently being called in:
- (CLLocationCoordinate2D)getRandomizedSearchCircle:(CLLocation *)cacheLocation {
    
    CLLocationDegrees randomizedCacheLatitude = cacheLocation.coordinate.latitude + (((float)arc4random_uniform(2)-.3))/ARC4RANDOM_MAX;
    CLLocationDegrees randomizedCacheLongitude = cacheLocation.coordinate.longitude + (((float)arc4random_uniform(2)-.3))/ARC4RANDOM_MAX;
    CLLocationCoordinate2D randomizedCircleCenter = CLLocationCoordinate2DMake(randomizedCacheLatitude, randomizedCacheLongitude);
    
    return randomizedCircleCenter;
    
}

//Sets class property currentUserLocation to the last logged location when a user moves
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self.currentUserLocation = locations.lastObject;
    
}

//Convenience method to get distances between current user location and a passed in cache location
- (CLLocationDistance)getDistance:(CLLocation *)cacheLocation {
    
    CLLocationDistance distance = [self.currentUserLocation distanceFromLocation:cacheLocation];
    
    return distance;
}


- (BOOL)canCompleteCache {
    
    CLLocationDistance distance = [self.currentUserLocation distanceFromLocation:self.cacheLocation];
    NSLog(@"%f", distance);
    
    if (distance < 10) {
        return YES;
    } else {
        return NO;
    }
}

@end
