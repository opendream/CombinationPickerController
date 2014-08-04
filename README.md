CombinationPickerController
===========================

CombinationPickerController is image picker use uicollection view.

 * can select only one image
 * can custom you camera else use default
 * support only portrait
 
Use cocoapods
  
  pod 'CombinationPickerController'

How to use

Add delegate 

  <ODMCombinationPickerViewControllerDelegate>

Create and present ODMCombinationPickerViewController

    ODMCombinationPickerViewController *vc = [[ODMCombinationPickerViewController alloc] initWithCombinationPickerNib];
    [vc setDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];

Delegate function


  - (void)imagePickerController:(ODMCombinationPickerViewController *)picker didFinishPickingAsset:(ALAsset *)asset;
  
  - (void)imagePickerControllerDidCancel:(ODMCombinationPickerViewController *)picker;


Custom camera controller

  YourCameraController *cameraController = [YourCameraController new]; 
  
  [vc setCameraController:cameraController];

