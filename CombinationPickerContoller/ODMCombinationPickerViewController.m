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

static NSString *CellIdentifier = @"photoCell";

@implementation ODMCombinationPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    previousBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    
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
    };
    
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Camera Roll"]) {
                
                self.assetsGroup = group;
                
            }
            
            [self.groups addObject:group];
            [self.collectionView reloadData];
            [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
            [self.assets insertObject:[UIImage imageNamed:@"camera-icon"] atIndex:0];

        }
        
    };
    
    
    // enumerate only photos
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:nil];
    
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];

    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
    [self.assetsGroup setAssetsFilter:onlyPhotosFilter];

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}

- (void)dealloc
{
    [[UIApplication sharedApplication] setStatusBarStyle:previousBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ODMCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    // load the asset for this cell
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
    [cell setHightlightBackground:[indexPath isEqual:selectedIndex]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"indexPath %@", indexPath);
    if (indexPath.row == 0) {

        selectedIndex = nil;

        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    } else {

        
        if ([selectedIndex isEqual:indexPath] ) {
            
            selectedIndex = nil;
            
        } else {
            
            selectedIndex = indexPath;
            
        }
        
        
    }
    
    [self.collectionView reloadData];
    [self checkDoneButton];

    

}

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
            [self.assets insertObject:[UIImage imageNamed:@"camera-icon"] atIndex:0];
            
            [self.collectionView reloadData];
            
            [self.navagationTitleButton setTitle:[NSString stringWithFormat:@"%@ ▾", [menu title]] forState:UIControlStateNormal];
        }
    }
}


#pragma marl -

- (void)checkDoneButton
{
    if (selectedIndex != nil) {
        
        [self.doneButton setEnabled:YES];
        
    } else {
        
        [self.doneButton setEnabled:NO];
        
    }
}

#pragma mark - action

- (IBAction)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImage:)]) {
        
        ALAsset *asset = self.assets[selectedIndex.row];
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        
        [self.delegate imagePickerController:self didFinishPickingImage:[UIImage imageWithCGImage:iref]];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    
    if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImage:)]) {
        
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.delegate imagePickerController:self didFinishPickingImage:originImage];
        
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
