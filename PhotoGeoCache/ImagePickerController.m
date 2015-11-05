//
//  ImagePickerController.m
//  PhotoGeoCache
//
//  Created by Christian Monson on 8/20/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import "ImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>
#import "Cache.h"
#import "CacheController.h"
#import "PrimaryCollectionViewController.h"

@interface ImagePickerController ()

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *chosenImageView;

@end

@implementation ImagePickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imagePicker = [UIImagePickerController new];
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.delegate = self;
//    self.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }
    else {
        self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString* mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqual:kUTTypeImage]) {
        UIImage *chosenImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        self.chosenImageView.image = chosenImage;
        
        if ([self.cameraType isEqualToString: @"newCacheCamera"]) {
            
            [[CacheController sharedInstance] addCacheWithInfo: [MapDataController sharedInstance].currentUserLocation photo:chosenImage rating:@10 difficultyRating:@10 difficultySetting:@"easy" type:@"1" addedByUser:@"user"];
            //^passing in dummy data
            
        } else if ([self.cameraType isEqualToString: @"foundCacheCamera"]) {
            UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
        }
    };
//    [self.dismissDelegate popFromModalToRootViewControllerMethod];
//    [self performSegueWithIdentifier:@"myUnwindIdentifier" sender:self];
//    [self popToRootViewControllerAnimated:YES];
    
    //[self performSegueWithIdentifier:@"unwind" sender:nil];
    
    //[self unwindFromImagePicker:[UIStoryboardSegue segueWithIdentifier:@"myUnwindIdentifier" source: self destination:[PrimaryCollectionViewController new] performHandler:^{
    //}]];
}

- (void)didPushDismissButton {
    
    [self.dismissDelegate popFromModalToRootViewControllerMethod];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)clear {
    self.chosenImageView.image = nil;
    self.titleTextField.text = nil;
}

- (IBAction)share:(id)sender {
    if (self.chosenImageView.image) {
        NSData *imageData = UIImagePNGRepresentation(self.chosenImageView.image);
        PFFile *photoFile = [PFFile fileWithData:imageData];
        PFObject *photo = [PFObject objectWithClassName:@"Photo"];
        photo[@"image"] = photoFile;
        photo[@"whoTook"] = [PFUser currentUser];
        photo[@"title"] = self.titleTextField.text;
        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
//                [self showError];
            }
        }];
    }
    else {
//        [self showError];
    }
    [self clear];
    [self.tabBarController setSelectedIndex:0];
}

//- (void)showError {
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Could not post your photo, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.titleTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.dismissDelegate popFromModalToRootViewControllerMethod];
    [self dismissViewControllerAnimated:YES completion: ^{
        [self performSegueWithIdentifier:@"myUnwindIdentifier" sender:self];
        [self popToRootViewControllerAnimated:NO];
    }];
    [self clear];
}



//- (IBAction)unwindFromImagePicker:(UIStoryboardSegue *)segue {
//    [self dismissViewControllerAnimated:YES completion: ^{
//        [self popToRootViewControllerAnimated:NO];
//    }];
//}

@end
