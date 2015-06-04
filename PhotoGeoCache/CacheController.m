//
//  CacheController.m
//  PhotoGeoCache
//
//  Created by Austin Mecham on 6/2/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "CacheController.h"
#import "MapDataController.h"

@interface CacheController ()

@property (strong, nonatomic) CLLocation *currentLocation; //!!!to be used as part of dummy location. Remove when location manager is functional!!!

@end

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
    
    self.currentLocation = [[CLLocation alloc] initWithLatitude:40.7708 longitude:-111.892];
    
    NSMutableArray *photoArray = [[query findObjects] mutableCopy]; // your mutable copy of the fetched objects
    for (Cache *cache in photoArray) {
        PFGeoPoint *location = cache.location;
        CLLocation *photoLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        CLLocationDistance feet = [self.currentLocation distanceFromLocation: photoLocation];
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
