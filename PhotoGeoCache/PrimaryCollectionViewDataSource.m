//
//  PrimaryCollectionViewDataSource.m
//  PhotoGeoCache
//
//  Created by Austin Mecham on 5/29/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "PrimaryCollectionViewDataSource.h"
#import "PictureFeedCollectionViewCell.h"
#import "CacheController.h"
#import "Cache.h"

@implementation PrimaryCollectionViewDataSource

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[CacheController sharedInstance].caches count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    Cache *cache = [CacheController sharedInstance].caches[indexPath.item];
    cell.imageView.image = [UIImage imageWithData:cache.photo.getData];
//
    switch (indexPath.item % 6)
    {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"nightdrive"];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"clouds"];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"ghosted"];
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"lake"];
            break;
        case 4:
            cell.imageView.image = [UIImage imageNamed:@"night"];
            break;
        case 5:
            cell.imageView.image = [UIImage imageNamed:@"mountainside"];
            break;
        default:
            break;
    }
    
    cell.backgroundColor = [UIColor blackColor];
    
    
    return cell;
}

@end
