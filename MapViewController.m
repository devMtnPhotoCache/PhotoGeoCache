//
//  MapViewController.m
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#define METERS_MILE 1609.344
#define METERS_FEET 3.28084
#define ARC4RANDOM_MAX 0x100

#import "MapViewController.h"
#import "MapDataController.h"
#import "Cache.h"
#import "CameraViewController.h"

@interface UIViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) MKUserLocation *userLocation;
@property (nonatomic) BOOL showsUserLocation;
@property (nonatomic) BOOL userLocationUpdated;
@property (nonatomic) BOOL didAddOverlayRenderer;
@property (nonatomic) CLLocation *cacheLocation;
@property (nonatomic) CLLocationCoordinate2D circleCenter;


@end

@implementation MapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKUserTrackingBarButtonItem *userTrackerButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    
    UIBarButtonItem *displayCacheCircleButton = [[UIBarButtonItem alloc] initWithTitle:@"Show Cache"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:(self)
                                                                                action:@selector(displayCacheCircle)];
    
    self.navigationItem.rightBarButtonItems = @[userTrackerButton, displayCacheCircleButton];
    
    [self.mapView setShowsUserLocation:YES];
    
    [self.mapView setDelegate:self];
    
#pragma - Location Manager Setup
    
    if ([[MapDataController sharedInstance].locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[MapDataController sharedInstance].locationManager requestWhenInUseAuthorization];
    }
    
#pragma  - Playing with coordinates, drawing a circle
    
    Cache *currentCache = [Cache new];
    
    self.cacheLocation = [[CLLocation alloc] initWithLatitude:currentCache.location.latitude longitude:currentCache.location.longitude];
    
    self.circleCenter = [[MapDataController sharedInstance] getRandomizedSearchCircle:self.cacheLocation];
    
    //make a circle and give it coordinates
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:[[MapDataController sharedInstance] getRandomizedSearchCircle:(self.cacheLocation)] radius: .5*METERS_MILE];
    
    
    //add circle overlay to view
    [self.mapView addOverlay:circle];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = locations.lastObject;
    
    CLLocationDistance distance = [[MapDataController sharedInstance].locationManager.location distanceFromLocation:self.cacheLocation];
    NSLog(@"%f", distance);
    
    if (distance < 10) {
        NSLog(@"Congratulations");
        
    }
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2*METERS_MILE, 2*METERS_MILE);
    
    if (!self.userLocationUpdated) {
        [self.mapView setRegion:viewRegion animated:YES];
        self.userLocationUpdated = YES;
    }
}

//Zooms to Search Circle at view load
- (void) mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers {
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.circleCenter, 2*METERS_MILE, 2*METERS_MILE);
    
    if (!self.didAddOverlayRenderer) {
        [self.mapView setRegion:viewRegion animated:YES];
        self.didAddOverlayRenderer = YES;
    }
    
}

//Renderer for Circle
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay{
    
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
    
    circleRenderer.fillColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    circleRenderer.strokeColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    circleRenderer.lineWidth = 2;
    
    return circleRenderer;
    
}

- (void)displayCacheCircle {
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.circleCenter, 2*METERS_MILE, 2*METERS_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
    self.didAddOverlayRenderer = YES;
}

# pragma - alerts
- (void)cacheIncompleteAlert {
    
    UIAlertController *incompleteAlert = [UIAlertController alertControllerWithTitle:@"Too far from the cache!" message:@"Keep going! You can do it!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"You're right. I'll look some more" style:UIAlertActionStyleDefault handler:nil];
    
    [incompleteAlert addAction:confirmAction];
    
    [self presentViewController:incompleteAlert animated:YES completion:nil];
    
}

- (void)cacheCompleteAlert {
    
    UIAlertController *completeAlert = [UIAlertController alertControllerWithTitle:@"You did it! Congratulations!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *completeAction = [UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        CameraViewController *newCamera = [[CameraViewController alloc] init];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
                [self presentViewController:newCamera animated:YES completion:nil];
        });
        
    }];
    
    UIAlertAction *stayAction = [UIAlertAction actionWithTitle:@"Complete without a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [completeAlert addAction:completeAction];
    [completeAlert addAction:stayAction];
    
    [self presentViewController:completeAlert animated:YES completion:nil];
}

- (IBAction)finishButtonTapped:(id)sender {
    
    if ([[MapDataController sharedInstance] canCompleteCache] == YES) {
        [self cacheCompleteAlert];
    } else {
        [self cacheIncompleteAlert];
    }
}


@end
