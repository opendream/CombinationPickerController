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
        self.selectionHighlightColor = [UIColor greenColor];
        self.selectionBorderWidth = 1.0f;
    }
    return self;
}

- (void)setHightlightBackground:(BOOL)isSelected withAimate:(BOOL)animate
{
    [self.imageView.layer removeAllAnimations];
    [self.bgView.layer removeAllAnimations];
    [self.layer removeAllAnimations];
    
    if (isSelected == YES) {
        
        [self setHightlightBackground];
        
    } else {

        [self setNormalBackground:animate];
        
    }
}

- (void)setNormalBackground:(BOOL)animate
{
    
    if (animate) {
        
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             [self.imageView setFrame:CGRectMake(self.imageView.frame.origin.x+self.selectionBorderWidth, self.imageView.frame.origin.y+self.selectionBorderWidth, self.imageView.frame.size.width-(self.selectionBorderWidth*2), self.imageView.frame.size.height-(self.selectionBorderWidth*2))];
                             
                             [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x+self.selectionBorderWidth, self.bgView.frame.origin.y+self.selectionBorderWidth, self.bgView.frame.size.width-(self.selectionBorderWidth*2), self.bgView.frame.size.height-(self.selectionBorderWidth*2))];
                             
                         }
                         completion:^(BOOL finished){
                             
                             [self.imageView setFrame:CGRectMake(self.imageView.frame.origin.x-self.selectionBorderWidth, self.imageView.frame.origin.y-self.selectionBorderWidth, self.imageView.frame.size.width+(self.selectionBorderWidth*2), self.imageView.frame.size.height+(self.selectionBorderWidth*2))];
                             
                             [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x-self.selectionBorderWidth, self.bgView.frame.origin.y-self.selectionBorderWidth, self.bgView.frame.size.width+(self.selectionBorderWidth*2), self.bgView.frame.size.height+(self.selectionBorderWidth*2))];
                             
                         }
         ];

    }
    
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    
}

- (void)setHightlightBackground
{
    self.bgView.layer.borderWidth = self.selectionBorderWidth;
    self.bgView.layer.borderColor = self.selectionHighlightColor.CGColor;
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         [self.imageView setFrame:CGRectMake(self.imageView.frame.origin.x+self.selectionBorderWidth, self.imageView.frame.origin.y+self.selectionBorderWidth, self.imageView.frame.size.width-(self.selectionBorderWidth*2), self.imageView.frame.size.height-(self.selectionBorderWidth*2))];
                         
                         [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x+self.selectionBorderWidth, self.bgView.frame.origin.y+self.selectionBorderWidth, self.bgView.frame.size.width-(self.selectionBorderWidth*2), self.bgView.frame.size.height-(self.selectionBorderWidth*2))];
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self.imageView setFrame:CGRectMake(self.imageView.frame.origin.x-self.selectionBorderWidth, self.imageView.frame.origin.y-self.selectionBorderWidth, self.imageView.frame.size.width+(self.selectionBorderWidth*2), self.imageView.frame.size.height+(self.selectionBorderWidth*2))];
                         
                         [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x-self.selectionBorderWidth, self.bgView.frame.origin.y-self.selectionBorderWidth, self.bgView.frame.size.width+(self.selectionBorderWidth*2), self.bgView.frame.size.height+(self.selectionBorderWidth*2))];
                         
                     }
     ];
}

@end
