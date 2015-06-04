//
//  CacheController.h
//  PhotoGeoCache
//
//  Created by Austin Mecham on 6/2/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cache.h"
#import "MapDataController.h"

@interface CacheController : NSObject

+ (CacheController *)sharedInstance;

- (NSArray *)caches;
- (void)addCacheWithInfo:(CLLocation *)location photo:(UIImage *)photo rating:(NSNumber *)rating difficultyRating: (NSNumber *)difficultyRating difficultySetting:(NSString *)difficultySetting type:(NSString *)type addedByUser:(NSString *)addedByUser;

@end
