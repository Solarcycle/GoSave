//
//  InputCarViewController.h
//  Go Save
//
//  Created by KRS on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class FillUpViewController;
@class OtherCarCostViewController;
@class ResultViewController;

@interface InputCarViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate, ADBannerViewDelegate> {
    NSArray*    aryFillUp;
    UITextField*    myTextField;
}

@property (nonatomic, retain) IBOutlet FillUpViewController *fillupViewController;
@property (nonatomic, retain) IBOutlet OtherCarCostViewController *otherCarCostViewController;
@property (nonatomic, retain) IBOutlet ResultViewController *resultViewController;
@property (nonatomic, retain) IBOutlet UITableView *fillTable;
@property (nonatomic, retain) IBOutlet UIButton *btnResults;
@property (nonatomic, retain) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, retain) IBOutlet ADBannerView *banner;
@property (nonatomic, retain) IBOutlet UILabel *labelCarName;

-(void)createADBannerView;
- (void)layoutForCurrentOrientation:(BOOL)animated;

- (IBAction)otherCarCost:(id)sender;
- (IBAction)textFieldFinished:(id)sender;
- (BOOL)isValidFillData:(int)nIndx;
- (IBAction)clickMainMenu:(id)sender;
- (IBAction)clickResult:(id)sender;

- (void)save;
- (int)getValidDataCount;
- (void) alert;

@end
