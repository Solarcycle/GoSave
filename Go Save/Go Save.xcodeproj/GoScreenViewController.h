//
//  GoScreenViewController.h
//  Go Save
//
//  Created by KRS on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapDetectingView.h"
#import <iAd/iAd.h>


@interface GoScreenViewController : UIViewController<UITextFieldDelegate, TapDetectingViewDelegate, ADBannerViewDelegate> {
    UITextField*    textAlternativeGreen;
    UITextField*    textSavings;
    UITextField*    textBusPass;
    UITextField*    textLightRailPass;
    UITextField*    textTrainPass;
    UITextField*    textSubwayPass;
    UITextField*    textTaxi;
    UITextField*    textRentalCar;

    double           fBusPass;
    double           fLightRailPass;
    double           fTrainPass;
    double           fSubwayPass;
    double           fTaxi;
    double           fRentalCar;
    
    
    double          f;
    double          c;
    double          z;
    double          b;
    double          s;
    double          fOtherCarCost;

    double          f1;
    double          c1;
    double          z1;
    double          b1;
    double          s1;
    double          fOtherCarCost1;
}

@property (nonatomic, retain) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, retain) IBOutlet UISwitch *switchUseModifiedValues;
@property (nonatomic, retain) IBOutlet UISwitch *switchToWorkOnly;
@property (nonatomic, retain) IBOutlet UISwitch *switchGetRidOfCar;
@property (nonatomic, retain) IBOutlet UIImageView *imageSaving;
@property (nonatomic, retain) IBOutlet TapDetectingView *tapView;
@property (nonatomic, retain) IBOutlet ADBannerView *banner;

- (IBAction)clickMainMenu:(id)sender;
- (IBAction)clickResults:(id)sender;
- (IBAction)textFieldFinished:(id)sender;
- (IBAction)clickGerRidOfCar:(id)sender;
- (IBAction)clickModified:(id)sender;
- (IBAction)clickToWork:(id)sender;

- (void) addTextField;
- (void) save;
- (void) refresh;
- (double) total;
- (void) setData:(double)F F1:(double)F1 C:(double)C C1:(double)C1 Z:(double)Z Z1:(double)Z1 B:(double)B B1:(double)B1 S:(double)S S1:(double)S1 OtherCarCost:(double)OtherCarCost OtherCarCost1:(double)OtherCarCost1;
- (void) calc;
- (void) checkSwitch;

-(void)createADBannerView;
- (void)layoutForCurrentOrientation:(BOOL)animated;

@end
