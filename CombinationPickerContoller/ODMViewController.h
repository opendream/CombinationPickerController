//
//  ODMViewController.h
//  CombinationPickerContoller
//
//  Created by allfake on 7/31/14.
//  Copyright (c) 2014 Opendream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODMCombinationPickerViewController.h"

@interface ODMViewController : UIViewController <ODMCombinationPickerViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *selectedImageView;

@end
