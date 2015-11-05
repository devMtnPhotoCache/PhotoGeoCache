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

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate,ImagePickerHelperDelegate>

@property (nonatomic) MKUserLocation *userLocation;
@property (nonatomic) BOOL showsUserLocation;
@property (nonatomic) BOOL userLocationUpdated;
@property (nonatomic) BOOL didAddOverlayRenderer;
@property (nonatomic, strong) CLLocation *circleCenter;
@property (nonatomic) CLLocationCoordinate2D circleCenter2D;


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
    
    //old location for setting mapView Delegate
    
#pragma - Location Manager Setup
    
    if ([[MapDataController sharedInstance].locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[MapDataController sharedInstance].locationManager requestWhenInUseAuthorization];
    }
    
    [self updateWithCacheForLocation:self.cache];
    
}

#pragma Mark - Playing with coordinates, drawing a circle

- (void)updateWithCacheForLocation:(Cache *)cache {
    
    self.cacheLocation = [[CLLocation alloc] initWithLatitude:cache.location.latitude longitude:cache.location.longitude];
    
    self.circleCenter = [[MapDataController sharedInstance] getRandomizedSearchCircle:self.cacheLocation];
    
    //make a circle and give it coordinates
    self.circleCenter2D = CLLocationCoordinate2DMake(self.circleCenter.coordinate.latitude, self.circleCenter.coordinate.longitude);
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.circleCenter2D radius:.5*METERS_MILE];
    
    [self.mapView setDelegate:self];
    
    //add circle overlay to view
    [self.mapView addOverlay:circle];

    
}

//Zooms to Search Circle at view load
- (void) mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers {
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.circleCenter2D, 2*METERS_MILE, 2*METERS_MILE);
    
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
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.circleCenter2D, 2*METERS_MILE, 2*METERS_MILE);
    
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
    ImagePickerController *imagePickerController = [[ImagePickerController alloc] init];
    imagePickerController.cameraType = @"foundCacheCamera";
    imagePickerController.dismissDelegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:imagePickerController animated:YES completion:nil];
    });

}

/*- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self performSegueWithIdentifier:@"footloose" sender:nil];
}*/
//- (void)cacheCompleteAlert {
//    
//    UIAlertController *completeAlert = [UIAlertController alertControllerWithTitle:@"You did it! Congratulations!" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *completeAction = [UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
//        ImagePickerController *imagePickerController = [ImagePickerController new];
//        imagePickerController.cameraType = @"foundCacheCamera";
//        
//        dispatch_async(dispatch_get_main_queue(), ^ {
//                [self presentViewController:imagePickerController animated:YES completion:nil];
//        });
//        
//    }];
//    
//    UIAlertAction *stayAction = [UIAlertAction actionWithTitle:@"Complete without a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }];
//    
//    [completeAlert addAction:completeAction];
//    [completeAlert addAction:stayAction];
//    
//    [self presentViewController:completeAlert animated:YES completion:nil];
//}

- (IBAction)finishButtonTapped:(id)sender {
    
    if ([[MapDataController sharedInstance] canCompleteCache] == YES) {
        [self cacheCompleteAlert];
    } else {
        [self cacheIncompleteAlert];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ImagePickerController *imagePickerController = [segue destinationViewController];
    imagePickerController.dismissDelegate = self;
}

- (void)popFromModalToRootViewControllerMethod {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
