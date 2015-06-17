//
//  CacheDetailViewController.m
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "CacheDetailViewController.h"
#import "MapViewController.h"
#import "CacheController.h"
#import "Cache.h"

@interface CacheDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end

@implementation CacheDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailImage.image = self.selectedImage;
    
    [self updateWithCache:self.cache];
    
    [self.detailImage setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)updateWithCache:(Cache *)cache {
    self.detailImage.image = [UIImage imageWithData:cache.photo.getData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *mapViewController = [segue destinationViewController];
    mapViewController.cache = self.cache;
    
    
////    mapViewController.cacheLocation = [CacheController sharedInstance].caches[self.indexPath];
//    
//
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
