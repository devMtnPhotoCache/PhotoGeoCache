//
//  Rating.h
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import <Parse/Parse.h>

@interface Rating : PFObject <PFSubclassing>

@property (nonatomic, assign) int starValue;
@property (nonatomic, strong) NSString *UserThatLeftRating;
@property (nonatomic, strong) NSString *CacheName;
@property (nonatomic, strong) NSDate *date;

+ (NSString *)parseClassName;

@end
