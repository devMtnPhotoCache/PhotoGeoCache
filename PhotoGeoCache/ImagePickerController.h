//
//  ImagePickerController.h
//  PhotoGeoCache
//
//  Created by Christian Monson on 8/20/15.
//  Copyright (c) 2015 PhotoGeoCache. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagePickerHelperDelegate;

@interface ImagePickerController : UIImagePickerController <UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSString *cameraType;
@property (nonatomic, weak) id<ImagePickerHelperDelegate> dismissDelegate;

@end

@protocol ImagePickerHelperDelegate <NSObject>

@required
- (void)popFromModalToRootViewControllerMethod;

@end

