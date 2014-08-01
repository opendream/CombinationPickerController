//
//  ODMCollectionViewCell.m
//  CombinationPickerContoller
//
//  Created by allfake on 7/31/14.
//  Copyright (c) 2014 Opendream. All rights reserved.
//

#import "ODMCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ODMCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isSelected = NO;
    }
    return self;
}

- (void)markSelected:(BOOL)isSelected
{
    self.isSelected = isSelected;
}

- (void)setHightlightBackground:(BOOL)isSelected
{
    if (isSelected == YES) {
        
        self.bgView.layer.borderWidth = 0.8;
        self.bgView.layer.borderColor = [UIColor greenColor].CGColor;
        
    } else {

        self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
        
    }
}

@end
