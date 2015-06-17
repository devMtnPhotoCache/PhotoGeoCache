//
//  CacheDetailViewController.h
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "Cache.h"


@interface CacheDetailViewController : UIViewController

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UILabel *selectedLabel;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) Cache *cache;

@end
