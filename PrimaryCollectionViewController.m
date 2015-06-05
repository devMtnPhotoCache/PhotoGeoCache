//
//  PrimaryCollectionViewController.m
//  PhotoGeoCache
//
//  Created by Christian Monson on 5/21/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "PrimaryCollectionViewController.h"
#import "PictureFeedCollectionViewCell.h"
#import "CacheController.h"
#import <CoreLocation/CoreLocation.h>
#import "MapDataController.h"

@interface PrimaryCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LocationControllerDelegate>

//@property (strong, nonatomic) PrimaryCollectionViewControllerDataSource *dataSource;

@end

@implementation PrimaryCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CacheController sharedInstance] refreshCaches:^(BOOL empty) {
        if (!empty) {
            [self.collectionView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2.0, self.view.frame.size.width/2.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void) locationControllerDidUpdateLocation:(CLLocation *)location {

    // THIS WILL RELOAD COLLECTION VIEW EVERY TIME THE PHONE MOVES 5 MILES
    // YOU LIKELY WOULD BE BETTER OFF TO LET THE USER HIT RELOAD, OR ALERT
    // THEM AND LET THEM DECIDE IF THEY WANT TO RELOAD
    
    [[CacheController sharedInstance] refreshCaches:^(BOOL empty) {
        if (!empty) {
            [self.collectionView reloadData];
        }
    }];

    
}

- (void) viewWillAppear:(BOOL)animated {
    [[MapDataController sharedInstance] addLocationManagerDelegate:self];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[MapDataController sharedInstance] removelocationManagerDelegate:self];
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
