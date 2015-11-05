//
//  User.m
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "User.h"

@implementation User 

@dynamic Username;
@dynamic password;
@dynamic cachesCompleted;
@dynamic favoritesQueue;
@dynamic profilePicture;
@dynamic realName;
@dynamic friends;

+ (NSString *)parseClassName {
    return @"User";
}

+ (void)load {
    [self registerSubclass];
}
@end
