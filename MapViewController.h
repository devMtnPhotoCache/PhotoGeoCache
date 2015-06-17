//
//  MapViewController.h
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>
#import "Cache.h"

@import UIKit;

@interface MapViewController : UIViewController

@property (nonatomic) CLLocation *cacheLocation;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) Cache *cache;

- (void)displayCacheCircle;

@end