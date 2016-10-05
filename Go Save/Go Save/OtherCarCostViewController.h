//
//  OtherCarCostViewController.h
//  Go Save
//
//  Created by KRS on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapDetectingView.h"
#import <iAd/iAd.h>


@interface OtherCarCostViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate, TapDetectingViewDelegate, ADBannerViewDelegate> {
    UITextField*    textCost;
    UITextField*    textInsurance;
    UITextField*    textCarPayment;
    UITextField*    textMaintenance;
    UITextField*    textCarWash;
    UITextField*    textRegistration;
    UITextField*    textParking;
    
    
    double           fTotalCost;
    double           fInsurance;
    double           fCarPayment;
    double           fMaintenance;
    double           fCarwash;
    double           fRegistration;
    double           fParking;
}

@property (nonatomic, retain) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, retain) IBOutlet TapDetectingView *tapView;
@property (nonatomic, retain) IBOutlet ADBannerView *banner;


- (IBAction)clickMainMenu:(id)sender;
- (IBAction)clickResults:(id)sender;
- (IBAction)textFieldFinished:(id)sender;

- (void) addTextField;
- (void) refresh;
- (void) refreshText;
- (void) save;
- (double) total;
- (NSString*)realText:(NSString*)strOrg;

-(void)createADBannerView;
- (void)layoutForCurrentOrientation:(BOOL)animated;

@end
