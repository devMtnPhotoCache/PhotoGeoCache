//
//  FoundCacheObject.m
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "FoundCacheObject.h"

@implementation FoundCacheObject

@dynamic whoFoundIt;
@dynamic dateFound;
@dynamic cacheID;
@dynamic pointValue;
@dynamic photo;

+ (NSString *)parseClassName {
    return @"foundCache";
}

+ (void)load {
    [self registerSubclass];
}
@end
