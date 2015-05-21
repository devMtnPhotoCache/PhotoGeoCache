//
//  FoundCacheObject.h
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import <Parse/Parse.h>

@interface FoundCacheObject : PFObject

@property (nonatomic, strong) NSArray *whoFoundIt;
@property (nonatomic, strong) NSDate *dateFound;
@property (nonatomic, strong) NSString *cacheID;
@property (nonatomic, assign) int pointValue;
@property (nonatomic, strong) PFFile *photo;

@end
