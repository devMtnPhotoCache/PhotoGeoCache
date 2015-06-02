//
//  CacheObject.m
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "Cache.h"

@implementation Cache

@dynamic location;
@dynamic photo;
@dynamic rating;
@dynamic difficultyRating;
@dynamic difficultySetting;
@dynamic type;
@dynamic addedByUser;

//****Sample Location Code for debugging! Will use Parse data for Cache objects.*****

+ (NSString *)parseClassName {
    
    return @"Cache";
}

+ (void)load {
    [self registerSubclass];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.location = [[CLLocation alloc] initWithLatitude:40.7708 longitude:-111.8920];
        
    }
    return self;
}


@end
