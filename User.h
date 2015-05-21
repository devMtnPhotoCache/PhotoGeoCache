//
//  User.h
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFObject

@property (nonatomic, strong) NSString *Username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSArray *cachesCompleted;
@property (nonatomic, strong) NSArray *favoritesQueue;
@property (nonatomic, strong) PFFile *profilePicture;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSArray *friends;

@end

