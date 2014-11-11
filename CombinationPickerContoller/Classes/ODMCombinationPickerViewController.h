//
//  ODMViewController.h
//  CombinationPickerContoller
//
//  Created by allfake on 7/30/14.
//  Copyright (c) 2014 Opendream. All rights reserved.
//

static NSString *CellIdentifier = @"photoCell";

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol ODMCombinationPickerViewControllerDelegate;

@interface ODMCombinationPickerViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isHideNavigationbar;
    UIStatusBarStyle previousBarStyle;
    NSIndexPath *currentSelectedIndex;
    NSIndexPath *previousSelectedIndex;
}
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) UIImage *cameraImage;
@property (nonatomic, strong) UIViewController *cameraController;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIView *navigationView;
@property (nonatomic, strong) IBOutlet UIView *requestPermisstionView;
@property (nonatomic, strong) IBOutlet UIButton *navagationTitleButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;
@property (nonatomic, assign) BOOL showCameraButton; // default YES

@property (nonatomic, weak) id<ODMCombinationPickerViewControllerDelegate> delegate;

- (void)fadeStatusBar;
- (id)initWithCombinationPickerNib;
- (id)initWithCombinationPickerNibShowingCameraButton:(BOOL)showCameraButton;

@end

@protocol ODMCombinationPickerViewControllerDelegate <NSObject>

@optional

- (void)imagePickerController:(ODMCombinationPickerViewController *)picker didFinishPickingAsset:(ALAsset *)asset;
- (void)imagePickerControllerDidCancel:(ODMCombinationPickerViewController *)picker;

@end
