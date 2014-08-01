//
//  ODMViewController.h
//  CombinationPickerContoller
//
//  Created by allfake on 7/30/14.
//  Copyright (c) 2014 Opendream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol ODMCombinationPickerViewControllerDelegate;

@interface ODMCombinationPickerViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate>
{
    UIStatusBarStyle previousBarStyle;
    NSIndexPath *selectedIndex;
}
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIButton *navagationTitleButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;

@property (nonatomic, weak) id<ODMCombinationPickerViewControllerDelegate> delegate;

@end

@protocol ODMCombinationPickerViewControllerDelegate <NSObject>

@optional

- (void)imagePickerController:(ODMCombinationPickerViewController *)picker didFinishPickingImage:(UIImage *)image;
- (void)imagePickerControllerDidCancel:(ODMCombinationPickerViewController *)picker;

@end
