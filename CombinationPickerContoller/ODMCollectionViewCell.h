//
//  ODMCollectionViewCell.h
//  CombinationPickerContoller
//
//  Created by allfake on 7/31/14.
//  Copyright (c) 2014 Opendream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODMCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL isSelected;

- (void)markSelected:(BOOL)isSelected;
- (void)setHightlightBackground:(BOOL)isSelected;

@end
