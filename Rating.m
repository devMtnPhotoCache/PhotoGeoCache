//
//  Rating.m
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "Rating.h"

@implementation Rating

@dynamic starValue;
@dynamic UserThatLeftRating;
@dynamic CacheName;
@dynamic date;

+ (NSString *)parseClassName {
    return @"rating";
}

+ (void)load {
    [self registerSubclass];
}

@end
