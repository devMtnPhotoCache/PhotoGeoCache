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


@end
