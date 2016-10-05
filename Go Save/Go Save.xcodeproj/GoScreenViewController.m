//
//  GoScreenViewController.m
//  Go Save
//
//  Created by KRS on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoScreenViewController.h"
#import "Go_SaveAppDelegate.h"

@implementation GoScreenViewController
@synthesize switchToWorkOnly, switchGetRidOfCar, switchUseModifiedValues, myScrollView, tapView, imageSaving;
@synthesize banner;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [switchToWorkOnly release];
    [switchGetRidOfCar release];
    [switchUseModifiedValues release];
    [myScrollView release];
    [tapView release];
    banner.delegate = nil;
    [banner release]; banner = nil;
    [imageSaving release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self addTextField];
    
    [tapView myInit];
    [tapView setFrame:CGRectMake(0, 0, 320, 500)];
    [tapView setDelegate:self];
    
    [myScrollView setContentSize:CGSizeMake(320, 500)];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    banner.delegate = nil;
    banner = nil;
    
    if(banner == nil)
        [self createADBannerView];
}

- (void)viewDidUnload
{
    [self save];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    switchToWorkOnly.on = YES;
    switchGetRidOfCar.on = NO;
    
    [self refresh];
    [self checkSwitch];
    [self calc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self save];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickMainMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)clickResults:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addTextField {
    textAlternativeGreen = [[UITextField alloc] initWithFrame:CGRectMake(30, 62, 100, 39)];
    textAlternativeGreen.tag = 0;
    [textAlternativeGreen setTextAlignment:UITextAlignmentCenter];
    [textAlternativeGreen setEnabled:NO];
    textAlternativeGreen.keyboardType = UIKeyboardTypeDecimalPad;
    [textAlternativeGreen setDelegate:self];    
    [textAlternativeGreen setReturnKeyType:UIReturnKeyDone];
    [textAlternativeGreen addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:textAlternativeGreen];
    
    textSavings = [[UITextField alloc] initWithFrame:CGRectMake(190, 62, 100, 39)];
    textSavings.tag = 1;
    [textSavings setEnabled:NO];
    [textSavings setTextAlignment:UITextAlignmentCenter];
    textSavings.keyboardType = UIKeyboardTypeDecimalPad;
    [textSavings setDelegate:self];    
    [textSavings setReturnKeyType:UIReturnKeyDone];
    [textSavings addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:textSavings];
    
    textBusPass = [[UITextField alloc] initWithFrame:CGRectMake(30, 67, 100, 39)];
    textBusPass.tag = 2;
    [textBusPass setTextAlignment:UITextAlignmentCenter];
    textBusPass.keyboardType = UIKeyboardTypeDecimalPad;
    [textBusPass setDelegate:self];    
    [textBusPass setReturnKeyType:UIReturnKeyDone];
    [textBusPass addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [myScrollView addSubview:textBusPass];
    
    textLightRailPass = [[UITextField alloc] initWithFrame:CGRectMake(190, 67, 100, 39)];
    textLightRailPass.tag = 3;
    [textLightRailPass setTextAlignment:UITextAlignmentCenter];
    textLightRailPass.keyboardType = UIKeyboardTypeDecimalPad;
    [textLightRailPass setDelegate:self];    
    [textLightRailPass setReturnKeyType:UIReturnKeyDone];
    [textLightRailPass addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [myScrollView addSubview:textLightRailPass];

    textTrainPass = [[UITextField alloc] initWithFrame:CGRectMake(30, 167, 100, 39)];
    textTrainPass.tag = 4;
    [textTrainPass setTextAlignment:UITextAlignmentCenter];
    textTrainPass.keyboardType = UIKeyboardTypeDecimalPad;
    [textTrainPass setDelegate:self];    
    [textTrainPass setReturnKeyType:UIReturnKeyDone];
    [textTrainPass addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [myScrollView addSubview:textTrainPass];
    
    textSubwayPass = [[UITextField alloc] initWithFrame:CGRectMake(190, 167, 100, 39)];
    textSubwayPass.tag = 5;
    [textSubwayPass setTextAlignment:UITextAlignmentCenter];
    textSubwayPass.keyboardType = UIKeyboardTypeDecimalPad;
    [textSubwayPass setDelegate:self];    
    [textSubwayPass setReturnKeyType:UIReturnKeyDone];
    [textSubwayPass addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [myScrollView addSubview:textSubwayPass];
    
    textTaxi = [[UITextField alloc] initWithFrame:CGRectMake(30, 267, 100, 39)];
    textTaxi.tag = 6;
    [textTaxi setTextAlignment:UITextAlignmentCenter];
    textTaxi.keyboardType = UIKeyboardTypeDecimalPad;
    [textTaxi setDelegate:self];    
    [textTaxi setReturnKeyType:UIReturnKeyDone];
    [textTaxi addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [myScrollView addSubview:textTaxi];
    
    textRentalCar = [[UITextField alloc] initWithFrame:CGRectMake(190, 267, 100, 39)];
    textRentalCar.tag = 7;
    [textRentalCar setTextAlignment:UITextAlignmentCenter];
    textRentalCar.keyboardType = UIKeyboardTypeDecimalPad;
    [textRentalCar setDelegate:self];    
    [textRentalCar setReturnKeyType:UIReturnKeyDone];
    [textRentalCar addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [myScrollView addSubview:textRentalCar];
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder]; 
}

- (void) save
{
    Go_SaveAppDelegate* app = [Go_SaveAppDelegate sharedAppDelegate];
    NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
    
    NSString*   strBussPass = [NSString stringWithFormat:@"BusPass%d", [app getSelectedCar]];
    NSString*   strLightRailPass = [NSString stringWithFormat:@"LightRailPass%d", [app getSelectedCar]];
    NSString*   strTrainPass = [NSString stringWithFormat:@"TrainPass%d", [app getSelectedCar]];
    NSString*   strSubwayPass = [NSString stringWithFormat:@"SubwayPass%d", [app getSelectedCar]];
    NSString*   strTaxi = [NSString stringWithFormat:@"Taxi%d", [app getSelectedCar]];
    NSString*   strRentalCar = [NSString stringWithFormat:@"RentalCar%d", [app getSelectedCar]];
    
    fBusPass = [textBusPass.text doubleValue];
    fLightRailPass = [textLightRailPass.text doubleValue];
    fTrainPass = [textTrainPass.text doubleValue];
    fSubwayPass = [textSubwayPass.text doubleValue];
    fTaxi = [textTaxi.text doubleValue];
    fRentalCar = [textRentalCar.text doubleValue];
    
    [fetchData setDouble:fBusPass forKey:strBussPass];
    [fetchData setDouble:fLightRailPass forKey:strLightRailPass];
    [fetchData setDouble:fTrainPass forKey:strTrainPass];
    [fetchData setDouble:fSubwayPass forKey:strSubwayPass];
    [fetchData setDouble:fTaxi forKey:strTaxi];
    [fetchData setDouble:fRentalCar forKey:strRentalCar];
}

- (double) total
{
    return fBusPass + fLightRailPass + fTrainPass + fSubwayPass + fTaxi + fRentalCar;
}

- (void) refresh
{
    Go_SaveAppDelegate* app = [Go_SaveAppDelegate sharedAppDelegate];
    NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
    
    NSString*   strBussPass = [NSString stringWithFormat:@"BusPass%d", [app getSelectedCar]];
    NSString*   strLightRailPass = [NSString stringWithFormat:@"LightRailPass%d", [app getSelectedCar]];
    NSString*   strTrainPass = [NSString stringWithFormat:@"TrainPass%d", [app getSelectedCar]];
    NSString*   strSubwayPass = [NSString stringWithFormat:@"SubwayPass%d", [app getSelectedCar]];
    NSString*   strTaxi = [NSString stringWithFormat:@"Taxi%d", [app getSelectedCar]];
    NSString*   strRentalCar = [NSString stringWithFormat:@"RentalCar%d", [app getSelectedCar]];
    
    fBusPass = [fetchData doubleForKey:strBussPass];
    fLightRailPass = [fetchData doubleForKey:strLightRailPass];
    fTrainPass = [fetchData doubleForKey:strTrainPass];
    fSubwayPass = [fetchData doubleForKey:strSubwayPass];
    fTaxi = [fetchData doubleForKey:strTaxi];
    fRentalCar = [fetchData doubleForKey:strRentalCar];

    double fTotal = [self total];
    
    [textAlternativeGreen setText:[Go_SaveAppDelegate realText:[NSString stringWithFormat:@"%f", fTotal]]];
    [textBusPass setText:[Go_SaveAppDelegate realText:[NSString stringWithFormat:@"%f", fBusPass]]];
    [textLightRailPass setText:[Go_SaveAppDelegate realText:[NSString stringWithFormat:@"%f", fLightRailPass]]];
    [textTrainPass setText:[Go_SaveAppDelegate realText:[NSString stringWithFormat:@"%f", fTrainPass]]];
    [textSubwayPass setText:[Go_SaveAppDelegate realText:[NSString stringWithFormat:@"%f", fSubwayPass]]];
    [textTaxi setText:[Go_SaveAppDelegate realText:[NSString stringWithFormat:@"%f", fTaxi]]];
    [textRentalCar setText:[Go_SaveAppDelegate realText:[NSString stringWithFormat:@"%f", fRentalCar]]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    fBusPass = [textBusPass.text doubleValue];
    fLightRailPass = [textLightRailPass.text doubleValue];
    fTrainPass = [textTrainPass.text doubleValue];
    fSubwayPass = [textSubwayPass.text doubleValue];
    fTaxi = [textTaxi.text doubleValue];
    fRentalCar = [textRentalCar.text doubleValue];

    double fTotal = [self total];
    [textAlternativeGreen setText:[Go_SaveAppDelegate realText:[NSString stringWithFormat:@"%f", fTotal]]];
    
    [self calc];
}

#pragma mark TapDetectingViewDelegate methods

- (void)gotSingleTapAtPoint:(CGPoint)tapPoint {
    [textAlternativeGreen resignFirstResponder];
    [textBusPass resignFirstResponder];
    [textLightRailPass resignFirstResponder];
    [textTrainPass resignFirstResponder];
    [textSubwayPass resignFirstResponder];
    [textTaxi resignFirstResponder];
    [textRentalCar resignFirstResponder];
}

- (void)gotDoubleTapAtPoint:(CGPoint)tapPoint {
}

- (void)gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
}

- (void) setData:(double)F F1:(double)F1 C:(double)C C1:(double)C1 Z:(double)Z Z1:(double)Z1 B:(double)B B1:(double)B1 S:(double)S S1:(double)S1 OtherCarCost:(double)OtherCarCost OtherCarCost1:(double)OtherCarCost1;
{
    f = F;
    c = C;
    z = Z;
    b = B;
    s = S;
    fOtherCarCost = OtherCarCost;

    f1 = F1;
    c1 = C1;
    z1 = Z1;
    b1 = B1;
    s1 = S1;
    fOtherCarCost1 = OtherCarCost1;
}

- (void) calc
{
    double fTotal = [self total];
    
    double x = 0;
    
    if(switchUseModifiedValues.on == NO)
    {
        if(switchToWorkOnly.on == YES && switchGetRidOfCar.on == NO)
            x = f - fTotal - (30*c*z/b) - fOtherCarCost;
        else if(switchToWorkOnly.on == YES && switchGetRidOfCar.on == YES)
            x = f - fTotal;
        else if(switchToWorkOnly.on == NO && switchGetRidOfCar.on == YES)
            x = f - fTotal;
        else
            x = f - fTotal - fOtherCarCost;
    }
    else
    {
        if(switchToWorkOnly.on == YES && switchGetRidOfCar.on == NO)
            x = f - fTotal - fOtherCarCost;
        //            x = f1 - fTotal - (30*c1*s1/b1) - fOtherCarCost1;
        else if(switchToWorkOnly.on == YES && switchGetRidOfCar.on == YES)
            x = f - fTotal;
        else if(switchToWorkOnly.on == NO && switchGetRidOfCar.on == YES)
            x = f - fTotal;
        else
            x = f - fTotal - fOtherCarCost;
        //            x = f1 - fTotal;
    }

//    if(switchUseModifiedValues.on == NO)
//    {
//        if(switchToWorkOnly.on == YES && switchGetRidOfCar.on == NO)
//            x = f - fTotal - (30*c*z/b1) - fOtherCarCost;
//        else if(switchToWorkOnly.on == YES && switchGetRidOfCar.on == YES)
//            x = f - fTotal;
//        else if(switchToWorkOnly.on == NO && switchGetRidOfCar.on == YES)
//            x = f - fTotal;
//        else
//            x = f - fTotal - fOtherCarCost;
//    }
//    else
//    {
//        if(switchToWorkOnly.on == YES && switchGetRidOfCar.on == NO)
//            x = f1 - fTotal - fOtherCarCost1;
////            x = f1 - fTotal - (30*c1*s1/b1) - fOtherCarCost1;
//        else if(switchToWorkOnly.on == YES && switchGetRidOfCar.on == YES)
//            x = f1 - fTotal;
//        else if(switchToWorkOnly.on == NO && switchGetRidOfCar.on == YES)
//            x = f1 - fTotal;
//        else
//            x = f1 - fTotal - fOtherCarCost1;
////            x = f1 - fTotal;
//    }
        

    [textSavings setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", x] nPlaces:2]];
    
    if(x >= 0)
        [imageSaving setImage:[UIImage imageNamed:@"SavingGreen.png"]];
    else
        [imageSaving setImage:[UIImage imageNamed:@"SavingRed.png"]];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string 
{
    int nDecimalCount = 2;
    
//    switch (textField.tag) {
//        case 0:
//            nDecimalCount = 1;
//            break;
//        case 1:
//            nDecimalCount = 0;
//            break;
//        case 2:
//            nDecimalCount = 3;
//            break;
//        case 3:
//            nDecimalCount = 3;
//            break;
//            
//        default:
//            break;
//    }
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setNumberStyle:kCFNumberFormatterDecimalStyle]; 
    
    NSString* strText = [Go_SaveAppDelegate realTextDecimal:[textField.text stringByReplacingCharactersInRange:range withString:string] nPlaces:nDecimalCount];
    
    [textField setText:strText];
    
    return NO;
}

- (void) checkSwitch
{
    if(switchGetRidOfCar.on == YES)
    {
        [switchUseModifiedValues setEnabled:NO];
        [switchToWorkOnly setEnabled:NO];
    }
    else
    {
        [switchUseModifiedValues setEnabled:YES];
        [switchToWorkOnly setEnabled:YES];
    }
    
    [self calc];
}

- (IBAction)clickModified:(id)sender
{
    [self checkSwitch];
}

- (IBAction)clickToWork:(id)sender
{
    [self checkSwitch];
}

- (IBAction)clickGerRidOfCar:(id)sender
{
    [self checkSwitch];
}

-(void)createADBannerView
{
	NSString *contentSize;
	if (&ADBannerContentSizeIdentifierPortrait != nil)
	{
		contentSize = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifierLandscape;
	}
	else
	{
		// user the older sizes 
		contentSize = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifierLandscape;
    }
	
    // Calculate the intial location for the banner.
    // We want this banner to be at the bottom of the view controller, but placed
    // offscreen to ensure that the user won't see the banner until its ready.
    // We'll be informed when we have an ad to show because -bannerViewDidLoadAd: will be called.
    CGRect frame;
    frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:contentSize];
    frame.origin = CGPointMake(0.0f, self.myScrollView.contentSize.height-frame.size.height);
    
    // Now to create and configure the banner view
    ADBannerView *bannerView = [[ADBannerView alloc] initWithFrame:frame];
    // Set the delegate to self, so that we are notified of ad responses.
    bannerView.delegate = self;
    // Set the autoresizing mask so that the banner is pinned to the bottom
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    
	// Since we support all orientations in this view controller, support portrait and landscape content sizes.
    // If you only supported landscape or portrait, you could remove the other from this set
	bannerView.requiredContentSizeIdentifiers = (&ADBannerContentSizeIdentifierPortrait != nil) ?
    [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil] : 
    [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    
    // At this point the ad banner is now be visible and looking for an ad.
    [self.myScrollView addSubview:bannerView];
    self.banner = bannerView;
    [bannerView release];
}

-(void)layoutForCurrentOrientation:(BOOL)animated
{
    CGFloat animationDuration = animated ? 0.2f : 0.0f;
    // by default content consumes the entire view area
    CGRect contentFrame = self.view.bounds;
    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by the banner height to get the final position
	CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat bannerHeight = 0.0f;
    
    // First, setup the banner's content size and adjustment based on the current orientation
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
		banner.currentContentSizeIdentifier = (&ADBannerContentSizeIdentifierLandscape != nil) ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifierLandscape;
    else
        banner.currentContentSizeIdentifier = (&ADBannerContentSizeIdentifierPortrait != nil) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifierPortrait; 
    bannerHeight = banner.bounds.size.height; 
	
    // Depending on if the banner has been loaded, we adjust the content frame and banner location
    // to accomodate the ad being on or off screen.
    // This layout is for an ad at the bottom of the view.
    if(banner.bannerLoaded)
    {
        contentFrame.size.height -= bannerHeight;
		bannerOrigin.y -= bannerHeight;
    }
    else
    {
		bannerOrigin.y += bannerHeight;
    }
    
    // And finally animate the changes, running layout for the content view if required.
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         banner.frame = CGRectMake(bannerOrigin.x, bannerOrigin.y, banner.frame.size.width, banner.frame.size.height);
                     }];
}

#pragma mark -
#pragma mark ADBannerViewDelegate methods

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    //    [self layoutForCurrentOrientation:YES];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    //    [self layoutForCurrentOrientation:YES];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

@end
