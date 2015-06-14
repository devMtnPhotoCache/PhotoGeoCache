//
//  CacheController.m
//  PhotoGeoCache
//
//  Created by Austin Mecham on 6/2/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "CacheController.h"
#import "PrimaryCollectionViewController.h"

@interface CacheController()

@property (nonatomic, strong) NSArray *caches;

@end


@implementation CacheController

+ (instancetype)sharedInstance { 
    
    static CacheController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CacheController alloc] init];
    });
    return sharedInstance;
}

- (void)refreshCaches:(void (^)(BOOL empty))completion {

    [self requestLocations:^(NSArray *caches) {
        self.caches = caches;
        if (caches.count > 0) {
            completion(NO);
        } else {
            completion(YES);
        }
//        NSLog(@"%@", caches);
    }];

}

- (void)requestLocations:(void (^)(NSArray *caches))completion {
    

    if ([MapDataController sharedInstance].currentUserLocation != nil) {

        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:[MapDataController sharedInstance].currentUserLocation];
        
        [[PFUser currentUser] setObject:geoPoint forKey:@"currentLocation"];
        [[PFUser currentUser] saveInBackground];
        
        PFQuery *query = [Cache query];
        [query whereKey:@"location" nearGeoPoint:geoPoint withinMiles:20];
        query.limit = 20;
        
        NSMutableArray *photoArray = [[query findObjects] mutableCopy];
        completion(photoArray);

    } else {
        
        completion(nil);
        
    }

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
