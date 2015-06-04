//
//  CacheController.m
//  PhotoGeoCache
//
//  Created by Austin Mecham on 6/2/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "CacheController.h"
#import "PrimaryCollectionViewController.h"


@implementation CacheController

+ (instancetype)sharedInstance { 
    
    static CacheController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CacheController alloc] init];
        [sharedInstance loadCacheFromParse];
    });
    return sharedInstance;
}


//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [[MapDataController sharedInstance]setDelegate:self];
//        [[MapDataController sharedInstance].locationManager startUpdatingLocation];
//    }
//    return self;
//}


- (void)loadCacheFromParse {
    
    PFQuery *query = [Cache query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        for (Cache *cache in objects) {
            [cache pin];
        }
    }];
}

- (NSArray *)caches {
    
    PFQuery *query = [Cache query];
    [query fromLocalDatastore];
    
    NSMutableArray *photoArray = [[query findObjects] mutableCopy]; // your mutable copy of the fetched objects
    for (Cache *cache in photoArray) {
        PFGeoPoint *location = cache.location;
        CLLocation *photoLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        CLLocationDistance feet = [[MapDataController sharedInstance] getDistance:photoLocation];
        cache.currentDistance = feet;
    
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"currentDistance" ascending:YES];
    [photoArray sortUsingDescriptors:@[sort]];
    
    return photoArray;
}

- (void)addCacheWithInfo:(CLLocation *)location photo:(UIImage *)photo rating:(NSNumber *)rating difficultyRating: (NSNumber *)difficultyRating difficultySetting:(NSString *)difficultySetting type:(NSString *)type addedByUser:(NSString *)addedByUser {
    
    Cache *cache = [Cache object];
    
    if (photo) {
        PFFile *imagePhoto = [PFFile fileWithData:UIImageJPEGRepresentation(photo, 0.95)];
        cache.photo = imagePhoto;
    }
    
    if (location) {
        PFGeoPoint *geoLocation = [PFGeoPoint geoPointWithLocation:location];
        cache.location = geoLocation;
    }
    
    cache.rating = rating;
    cache.difficultyRating = difficultyRating;
    cache.difficultySetting = difficultySetting;
    cache.type = type;
    cache.addedByUser = addedByUser;
    
    
    [cache save];
}

- (void)removeCache:(Cache *)cache {
    
    
    [cache deleteInBackground];
}

- (void)addCache:(Cache *)cache {
    
  
    [cache save];
}



@end
