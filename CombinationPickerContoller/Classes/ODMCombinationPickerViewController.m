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

- (id)initWithCombinationPickerNib
{
    self = [super initWithNibName:@"ODMCombinationPickerViewController" bundle:nil];
    self.showCameraButton = YES;
    return self;
}

- (id)initWithCombinationPickerNibShowingCameraButton:(BOOL)showCameraButton
{
    self = [super initWithNibName:@"ODMCombinationPickerViewController" bundle:nil];
    self.showCameraButton = showCameraButton;
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.cameraImage == nil) {
        self.cameraImage = [UIImage imageNamed:@"camera-icon"];
    }
    
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
        
        [self viewForAuthorizationStatus];
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                
                self.assetsGroup = group;
                
                if (self.assets.count == 0) {
                    
                    [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
                    
                    [self addImageFirstRow];
                    
                }
                
                [self setNavigationTitle:[group valueForProperty:ALAssetsGroupPropertyName]];
                
                [self.groups insertObject:group atIndex:0];
                
            }
            else {
                [self.groups addObject:group];
            }
        }
        
        
    };
    
    // enumerate only photos
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        [self viewForAuthorizationStatus];
    }];
    
    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
    [self.assetsGroup setAssetsFilter:onlyPhotosFilter];
    
    [self checkDoneButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!previousBarStyle) {
        previousBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    }
    
    isHideNavigationbar = self.navigationController.isNavigationBarHidden;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self fadeStatusBar];
    [self setLightStatusBar];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self reStoreNavigationBar];
    [self fadeStatusBar];
    [self setBackStatusBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewForAuthorizationStatus
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if (status == ALAuthorizationStatusAuthorized || status == ALAuthorizationStatusNotDetermined) {
        [self.requestPermisstionView setHidden:YES];
    } else {
        [self.requestPermisstionView setHidden:NO];
    }
    
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
        thumbnailImageRef = [asset aspectRatioThumbnail];
        if (thumbnailImageRef == nil) {
            thumbnailImageRef = [asset thumbnail];
        }
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
            
            id delegate;
            if ([self.cameraController valueForKey:@"delegate"]) {
                delegate = [self.cameraController valueForKey:@"delegate"];
            }
            
            NSData *tempArchiveViewController = [NSKeyedArchiver archivedDataWithRootObject:self.cameraController];
            UIViewController *cameraVC = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveViewController];
            
            if (delegate && delegate != nil) {
                [cameraVC setValue:delegate forKey:@"delegate"];
            }
            
            [self presentViewController:cameraVC animated:YES completion:NULL];
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
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] && self.showCameraButton == YES) {
        
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
    if(self.didFinishPickingAsset) {
        self.didFinishPickingAsset(self, self.assets[currentSelectedIndex.row]);
    }

    if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingAsset:)]) {
        
        [self.delegate imagePickerController:self didFinishPickingAsset:self.assets[currentSelectedIndex.row]];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:originImage.CGImage
                                 metadata:[info objectForKey:UIImagePickerControllerMediaMetadata]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              
                              [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {

                                  if(self.didFinishPickingAsset) {
                                      self.didFinishPickingAsset(self, asset);
                                  }

                                  if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingAsset:)]) {
                                      [self.delegate imagePickerController:self didFinishPickingAsset:asset];
                                  }
                                  
                              } failureBlock:^(NSError *error) {
                                  
                                  NSLog(@"error couldn't get photo");
                                  
                              }];
                              
                          }];
}

- (IBAction)cancel:(id)sender
{
    if(self.didCancel) {
        self.didCancel(self);
    }

    if ([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    }
}

#pragma mark - Status bar

- (void)fadeStatusBar
{
    if ([[UIApplication sharedApplication] isStatusBarHidden]) {
        
        // need to animate
        //        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)setLightStatusBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setBackStatusBar
{
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:previousBarStyle];
        [self setNeedsStatusBarAppearanceUpdate];
        
    }
}

- (void)reStoreNavigationBar
{
    [self.navigationController setNavigationBarHidden:isHideNavigationbar animated:NO];
}

@end
