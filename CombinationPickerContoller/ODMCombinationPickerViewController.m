//
//  ODMViewController.m
//  CombinationPickerContoller
//
//  Created by allfake on 7/30/14.
//  Copyright (c) 2014 Opendream. All rights reserved.
//

#import "ODMCombinationPickerViewController.h"
#import "ODMCollectionViewCell.h"
#import "KxMenu.h"

@interface ODMCombinationPickerViewController ()

@end

@implementation ODMCombinationPickerViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setToolbarHidden:YES animated:NO];

    if (self.cameraImage == nil) {
        self.cameraImage = [UIImage imageNamed:@"camera-icon"];
    }
    
    if (!previousBarStyle) {
        previousBarStyle = [[UIApplication sharedApplication] statusBarStyle];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [self setNeedsStatusBarAppearanceUpdate];
            
        }];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    UINib *cellNib = [UINib nibWithNibName:
                      NSStringFromClass([ODMCollectionViewCell class])
                                    bundle:nil];

    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:CellIdentifier];
    
    
    if (self.assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    if (self.groups == nil) {
        _groups = [[NSMutableArray alloc] init];
    } else {
        [self.groups removeAllObjects];
    }
    
    if (!self.assets) {
        _assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets insertObject:result atIndex:0];
        }
        
        if ([self.assetsGroup numberOfAssets] - 1 == index) {
            
            [self.collectionView reloadData];
            
        }
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            
            [self.groups addObject:group];
            
            self.assetsGroup = [self.groups firstObject];
            [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
            
            [self addImageFirstRow];
            
            [self setNavigationTitle:[[self.groups firstObject] valueForProperty:ALAssetsGroupPropertyName]];
            
        }
        
    };
    
    // enumerate only photos
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        NSLog(@"Can not get group");
    }];
    
    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
    [self.assetsGroup setAssetsFilter:onlyPhotosFilter];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}

- (void)dealloc
{
    [[UIApplication sharedApplication] setStatusBarStyle:previousBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ODMCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    ALAsset *asset;
    CGImageRef thumbnailImageRef;
    UIImage *thumbnail;
    
    if ([self.assets[indexPath.row] isKindOfClass:[UIImage class]]) {
        
        thumbnail = self.assets[indexPath.row];
        
    } else {
        
        asset = self.assets[indexPath.row];
        thumbnailImageRef = [asset thumbnail];
        thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
        
    }
    
    cell.imageView.image = thumbnail;
    
    BOOL isSelected = [indexPath isEqual:currentSelectedIndex];
    BOOL isDeselectedShouldAnimate = currentSelectedIndex == nil && [indexPath isEqual:previousSelectedIndex];
    
    [cell setHightlightBackground:isSelected withAimate:isDeselectedShouldAnimate];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            
        previousSelectedIndex = nil;
        currentSelectedIndex = nil;

        if (self.cameraController != nil) {
            
            [self presentViewController:self.cameraController animated:YES completion:NULL];
            
        } else {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
            
        }
        
    } else {

        previousSelectedIndex = currentSelectedIndex;
        
        if ([currentSelectedIndex isEqual:indexPath] ) {
            
            currentSelectedIndex = nil;
            
        } else {
            
            currentSelectedIndex = indexPath;
            
        }
        
    }
    
    [self.collectionView reloadData];
    [self checkDoneButton];
}

- (void)changeGroup:(KxMenuItem *)menu
{
    for (ALAssetsGroup *group in self.groups) {
        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:[menu title]]) {
            self.assetsGroup = group;
            
            ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result) {
                    
                    [self.assets insertObject:result atIndex:0];
                    
                }
            };
            
            if (!self.assets) {
                _assets = [[NSMutableArray alloc] init];
            } else {
                [self.assets removeAllObjects];
            }
            
            [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];

            [self addImageFirstRow];
            
            [self.collectionView reloadData];
            
            [self setNavigationTitle:[menu title]];
        }
    }
    
    currentSelectedIndex = nil;
}


- (void)addImageFirstRow
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        
        [self.assets insertObject:self.cameraImage atIndex:0];
        
    }
}

- (void)setNavigationTitle:(NSString *)title
{
    [self.navagationTitleButton setTitle:[NSString stringWithFormat:@"%@ ▾", title] forState:UIControlStateNormal];

}

- (void)checkDoneButton
{
    if (currentSelectedIndex != nil) {
        
        [self.doneButton setEnabled:YES];
        
    } else {
        
        [self.doneButton setEnabled:NO];
        
    }
}

#pragma mark - action

- (IBAction)showMenu:(UIView *)sender
{
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    
    for (ALAssetsGroup *group in self.groups) {
        
        [menuItems addObject:[KxMenuItem menuItem:[group valueForProperty:ALAssetsGroupPropertyName]
                                            image:nil
                                           target:self
                                           action:@selector(changeGroup:)]];
    }
    
    if (menuItems.count) {
        [KxMenu showMenuInView:self.view
                      fromRect:sender.frame
                     menuItems:menuItems];
    }
}


- (IBAction)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingAsset:)]) {
        
        [self.delegate imagePickerController:self didFinishPickingAsset:self.assets[currentSelectedIndex.row]];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingAsset:)]) {
        
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:originImage.CGImage
                                     metadata:[info objectForKey:UIImagePickerControllerMediaMetadata]
                              completionBlock:^(NSURL *assetURL, NSError *error) {
                                  
                                  [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                      [self.delegate imagePickerController:self didFinishPickingAsset:asset];

                                  } failureBlock:^(NSError *error) {
                                      
                                      NSLog(@"error couldn't get photo");
                                      
                                  }];
                                  
                              }];
    }

}

- (IBAction)cancle:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarStyle:previousBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
    
    if ([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    }
}

@end
