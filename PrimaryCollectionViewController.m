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
#import "CacheDetailViewController.h"
#import "ImagePickerController.h"
@import Parse;
@import ParseUI;



@interface PrimaryCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LocationControllerDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) PFUser *currentUser;

//@property (strong, nonatomic) PrimaryCollectionViewControllerDataSource *dataSource;

@end

@implementation PrimaryCollectionViewController
@dynamic collectionView;


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *titleImage = [UIImage imageNamed:@"headerTitleImage.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:titleImage];;
   // self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:68 green:184 blue:106 alpha:1];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration{
    
    [self.collectionView.collectionViewLayout invalidateLayout];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width/2.0, self.view.frame.size.width/2.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(PictureFeedCollectionViewCell *)sender
{
    if ([segue.identifier isEqualToString:@"detailIdentifier"]){
        CacheDetailViewController *cacheDetailViewController = [segue destinationViewController];
        cacheDetailViewController.selectedImage = sender.imageView.image;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        Cache *cache = [CacheController sharedInstance].caches[indexPath.row];
        cacheDetailViewController.cache = cache;
        
    }
}

#pragma Parse Login

- (IBAction)signUp:(id)sender {
    PFSignUpViewController *signUp = [PFSignUpViewController new];
    signUp.delegate = self;
    [self presentViewController:signUp animated:YES completion:nil];
    
}

- (IBAction)signIn:(id)sender {
    PFLogInViewController *logIn = [PFLogInViewController new];
    logIn.delegate = self;
    [self presentViewController:logIn animated:YES completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    self.currentUser = user;
    
    [self addUserData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    self.currentUser = user;
    
    [self addUserData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)addUserData {
    
    PFQuery *query = [PFQuery queryWithClassName:@"yourData"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if ([objects count] == 0) {
            
            PFObject *yourData = [PFObject objectWithClassName:@"yourData"];
            yourData[@"dictionaryKey"] = @"dictionaryValue";
            
            // If there is a current user you can set that user as the only user that can access this object:
            if (self.currentUser) {
                yourData.ACL = [PFACL ACLWithUser:self.currentUser];
            }
            
            [yourData saveInBackground];
            
        } else {
            
            NSLog(@"You already stored your data");
        }
        
    }];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [[MapDataController sharedInstance] addLocationManagerDelegate:self];
    [[CacheController sharedInstance] refreshCaches:^(BOOL empty) {
        if (!empty) {
            [self.collectionView reloadData];
        }
    }];
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
