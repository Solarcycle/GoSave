//
//  ResultViewController.h
//  Go Save
//
//  Created by KRS on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "TapDetectingView.h"

@class GoScreenViewController;

@interface ResultViewController : UIViewController<UITextFieldDelegate, ADBannerViewDelegate, TapDetectingViewDelegate> {
    UITextField*    textCarTotal;
    UITextField*    textFuelCost;
    UITextField*    textWorkMilesPerFill;
    UITextField*    textDaysPerFill;

    NSArray*    aryFillUp;
    
    float a;
    float j;
    float p;
    float c;
    float w;
    int   d;
    float e;
    float q;
    float s;
    float m1, m2;
    float w1, w2;
    float z;
    float d1, d2;
    float b;
    float t;
    float y;
    float u;
    float h;
    float f;
    
    float fInsurance;
    float fCarPayment;
    float fMaintenance;
    float fCarwash;
    float fRegistration;
    float fParking;
    
    float fTotalOtherCost;
    float fTotal;
}

@property (nonatomic, retain) IBOutlet GoScreenViewController *goScreenViewController;
@property (nonatomic, retain) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, retain) IBOutlet UILabel *labelMPG;
@property (nonatomic, retain) IBOutlet UILabel *labelNonWorkMilesPerDay;
@property (nonatomic, retain) IBOutlet UILabel *labelDistanceToWork;
@property (nonatomic, retain) IBOutlet UILabel *labelCarPaymentPerMonth;
@property (nonatomic, retain) IBOutlet UILabel *labelDollarPerGal;
@property (nonatomic, retain) IBOutlet UISlider *sldMPG;
@property (nonatomic, retain) IBOutlet UISlider *sldNonWorkMilesPerDay;
@property (nonatomic, retain) IBOutlet UISlider *sldDistanceToWork;
@property (nonatomic, retain) IBOutlet UISlider *sldCarPaymentPerMonth;
@property (nonatomic, retain) IBOutlet UISlider *sldDollarPerGal;
@property (nonatomic, retain) IBOutlet ADBannerView *banner;
@property (nonatomic, retain) IBOutlet TapDetectingView *tapView;

- (IBAction)textFieldFinished:(id)sender;
- (void) addTextField;
- (IBAction)clickMainMenu:(id)sender;
- (IBAction)clickFillUpData:(id)sender;
- (IBAction)clickReset:(id)sender;
- (IBAction)clickGoScreen:(id)sender;

- (IBAction)clickSldMPG:(id)sender;
- (IBAction)clickSldNonwork:(id)sender;
- (IBAction)clickSldDistance:(id)sender;
- (IBAction)clickSldCarPayment:(id)sender;
- (IBAction)clickSldDollarPerGal:(id)sender;

- (void)calc;
- (void)adjust;

-(void)createADBannerView;
- (void)layoutForCurrentOrientation:(BOOL)animated;
- (void)setData:(NSArray*)array;

- (void)load;
- (void)save;


@end
