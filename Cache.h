//
//  CacheObject.h
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import <Parse/Parse.h>

@interface Cache : PFObject <PFSubclassing>

@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) PFFile *photo;
@property (nonatomic, assign) NSNumber *rating;
@property (nonatomic, assign) NSNumber *difficultyRating;
@property (nonatomic, strong) NSString *difficultySetting;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *addedByUser;
@property (nonatomic, assign) double currentDistance;

+ (NSString *)parseClassName;

@end
