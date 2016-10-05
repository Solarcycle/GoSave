//
//  ProfileMenuViewController.h
//  Go Save
//
//  Created by KRS on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class InputCarViewController;
@class WebSiteViewController;

@interface ProfileMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ADBannerViewDelegate> {
    int     nSelectedImage;
    UIButton*   btnCar[3];
    UITextField*   curTextField;
    int nDeleteCar;
}

- (IBAction)textFieldFinished:(id)sender;
- (IBAction)addImage:(id)sender;
- (IBAction)goWeb:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *carTable;
@property (nonatomic, retain) IBOutlet InputCarViewController *inputViewController;
@property (nonatomic, retain) IBOutlet WebSiteViewController *websiteViewController;
@property (nonatomic, retain) IBOutlet ADBannerView *banner;

-(void)createADBannerView;
- (void)layoutForCurrentOrientation:(BOOL)animated;
- (void) animateTextField: (UIView*) textField up: (BOOL) up;
- (void) alert;

@end
