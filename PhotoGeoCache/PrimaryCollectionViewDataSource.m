//
//  PrimaryCollectionViewDataSource.m
//  PhotoGeoCache
//
//  Created by Austin Mecham on 5/29/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "PrimaryCollectionViewDataSource.h"
#import "PictureFeedCollectionViewCell.h"

@implementation PrimaryCollectionViewDataSource

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    switch (indexPath.item % 6)
    {
        case 0:
            cell.imageView.backgroundColor = [UIColor redColor];
            break;
        case 1:
            cell.imageView.backgroundColor = [UIColor orangeColor];
            break;
        case 2:
            cell.imageView.backgroundColor = [UIColor yellowColor];
            break;
        case 3:
            cell.imageView.backgroundColor = [UIColor greenColor];
            break;
        case 4:
            cell.imageView.backgroundColor = [UIColor blueColor];
            break;
        case 5:
            cell.imageView.backgroundColor = [UIColor purpleColor];
            break;
        default:
            break;
    }
    
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

@end
