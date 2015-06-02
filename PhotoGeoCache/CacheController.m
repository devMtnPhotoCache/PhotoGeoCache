//
//  CacheController.m
//  PhotoGeoCache
//
//  Created by Austin Mecham on 6/2/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "CacheController.h"

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
    return [query findObjects];
}

- (void)addCacheWithInfo:(CLLocation *)location photo:(PFFile *)photo rating:(NSNumber *)rating difficultyRating: (NSNumber *)difficultyRating difficultySetting:(NSString *)difficultySetting type:(NSString *)type addedByUser:(NSString *)addedByUser {
    
    Cache *cache = [Cache object];
    
    cache.location = location;
    cache.photo = photo;
    cache.rating = rating;
    cache.difficultyRating = difficultyRating;
    cache.difficultySetting = difficultySetting;
    cache.type = type;
    cache.addedByUser = addedByUser;
    
    [cache pinInBackground];
    [cache save];
}

- (void)removeCache:(Cache *)cache {
    
    [cache unpinInBackground];
    [cache deleteInBackground];
}

- (void)addCache:(Cache *)cache {
    
    [cache pinInBackground];
    [cache save];
}



@end
