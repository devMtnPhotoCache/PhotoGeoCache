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
#import "Cache.h"
#import "CacheModel.h"
@import UIKit;

@interface MapDataController () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationDegrees *randomizedCacheLocationLatitude;
@property (nonatomic) CLLocationDegrees *randomizedCacheLocationLongitude;
@property (nonatomic) CLLocation *cacheLocation;

@property (strong, nonatomic) NSMutableArray *observers;

@end

@implementation MapDataController

+ (instancetype)sharedInstance {
    static MapDataController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MapDataController alloc] init];
        
       Cache *currentCache = [Cache new];
        
        sharedInstance.cacheLocation = [[CLLocation alloc] initWithLatitude:currentCache.location.latitude longitude:currentCache.location.longitude];
        
    });
    
    return sharedInstance;
}

- (void)start {
    [self.locationManager startUpdatingLocation];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        _observers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)locationControllerDidUpdateLocation:(CLLocation *)location {
    self.currentUserLocation = location;
}

- (void)addLocationManagerDelegate:(id<LocationControllerDelegate>)delegate {
    if (![self.observers containsObject:delegate]) {
        [self.observers addObject:delegate];
    }
}

- (void)removelocationManagerDelegate:(id<LocationControllerDelegate>)delegate {
    if ([self.observers containsObject:delegate]) {
        [self.observers removeObject:delegate];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

}

//Sets class property currentUserLocation to the last logged location when a user moves
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    CLLocation *location = locations.lastObject;
    CLLocationDistance distance = [self getDistance:location];
    
    if (distance > 5 * 1600 || self.location == nil) { // 5 miles
        [self setLocation:locations.lastObject];
        self.currentUserLocation = locations.lastObject;
        
        for (id<LocationControllerDelegate>delegate in self.observers) {
            [delegate locationControllerDidUpdateLocation:locations.lastObject];
        }
    }
    
}


//Currently being called in:
- (CLLocation *)getRandomizedSearchCircle:(CLLocation *)cacheLocation {
    
    CLLocationDegrees randomizedCacheLatitude = cacheLocation.coordinate.latitude + (((float)arc4random_uniform(2)-.3))/ARC4RANDOM_MAX;
    CLLocationDegrees randomizedCacheLongitude = cacheLocation.coordinate.longitude + (((float)arc4random_uniform(2)-.3))/ARC4RANDOM_MAX;
    CLLocation *randomizedCircleCenter = [[CLLocation alloc] initWithLatitude:randomizedCacheLatitude longitude:randomizedCacheLongitude];
    
    return randomizedCircleCenter;
    
}


//Convenience method to get distances between current user location and a passed in cache location
- (CLLocationDistance)getDistance:(CLLocation *)cacheLocation {
    
    CLLocationDistance distance = [self.location distanceFromLocation:cacheLocation];
    
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
