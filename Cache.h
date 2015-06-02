//
//  CacheObject.h
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import <Parse/Parse.h>

@interface Cache : PFObject <PFSubclassing>

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) PFFile *photo;
@property (nonatomic, assign) int rating;
@property (nonatomic, assign) int difficultyRating;
@property (nonatomic, strong) NSString *difficultySetting;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *addedByUser;

+ (NSString *)parseClassName;

@end
