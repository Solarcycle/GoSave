//
//  OtherCarCostViewController.m
//  Go Save
//
//  Created by KRS on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OtherCarCostViewController.h"
#import "Go_SaveAppDelegate.h"


@implementation OtherCarCostViewController
@synthesize myScrollView, tapView;
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
    [myScrollView release];
    [tapView release];
    banner.delegate = nil;
    [banner release]; banner = nil;
    
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
//    [tapView setFrame:CGRectMake(0, 0, 320, 500)];
//    [tapView addSubview:myScrollView];
//    [myScrollView sendSubviewToBack:tapView];
    [tapView setDelegate:self];
    
    [myScrollView setContentSize:CGSizeMake(320, 500)];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    banner.delegate = nil;
    banner = nil;
    
    if(banner == nil)
        [self createADBannerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self save];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) addTextField {
    textCost = [[UITextField alloc] initWithFrame:CGRectMake(42, 48, 237, 39)];
    textCost.tag = 0;
    [textCost setTextAlignment:UITextAlignmentCenter];
    [textCost setDelegate:self];    
    textCost.keyboardType = UIKeyboardTypeDecimalPad;
    [textCost setReturnKeyType:UIReturnKeyDone];
    [textCost addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textCost setEnabled:NO];
    [self.view addSubview:textCost];
    
    textInsurance = [[UITextField alloc] initWithFrame:CGRectMake(30, 77, 100, 39)];
    textInsurance.tag = 1;
    [textInsurance setTextAlignment:UITextAlignmentCenter];
    [textInsurance setDelegate:self];    
    textInsurance.keyboardType = UIKeyboardTypeDecimalPad;
    [textInsurance setReturnKeyType:UIReturnKeyDone];
    [textInsurance addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [myScrollView addSubview:textInsurance];

    textCarPayment = [[UITextField alloc] initWithFrame:CGRectMake(190, 77, 100, 39)];
    textCarPayment.tag = 2;
    [textCarPayment setTextAlignment:UITextAlignmentCenter];
    [textCarPayment setDelegate:self];    
    textCarPayment.keyboardType = UIKeyboardTypeDecimalPad;
    [textCarPayment setReturnKeyType:UIReturnKeyDone];
    [textCarPayment addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [myScrollView addSubview:textCarPayment];

    textMaintenance = [[UITextField alloc] initWithFrame:CGRectMake(30, 177, 100, 39)];
    textMaintenance.tag = 3;
    [textMaintenance setTextAlignment:UITextAlignmentCenter];
    [textMaintenance setDelegate:self];    
    textMaintenance.keyboardType = UIKeyboardTypeDecimalPad;
    [textMaintenance setReturnKeyType:UIReturnKeyDone];
    [textMaintenance addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [myScrollView addSubview:textMaintenance];
    
    textCarWash = [[UITextField alloc] initWithFrame:CGRectMake(190, 177, 100, 39)];
    textCarWash.tag = 4;
    [textCarWash setTextAlignment:UITextAlignmentCenter];
    [textCarWash setDelegate:self];    
    textCarWash.keyboardType = UIKeyboardTypeDecimalPad;
    [textCarWash setReturnKeyType:UIReturnKeyDone];
    [textCarWash addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [myScrollView addSubview:textCarWash];

    textRegistration = [[UITextField alloc] initWithFrame:CGRectMake(30, 277, 100, 39)];
    textRegistration.tag = 4;
    [textRegistration setTextAlignment:UITextAlignmentCenter];
    [textRegistration setDelegate:self];    
    textRegistration.keyboardType = UIKeyboardTypeDecimalPad;
    [textRegistration setReturnKeyType:UIReturnKeyDone];
    [textRegistration addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [myScrollView addSubview:textRegistration];
    
    textParking = [[UITextField alloc] initWithFrame:CGRectMake(190, 277, 100, 39)];
    textParking.tag = 5;
    [textParking setTextAlignment:UITextAlignmentCenter];
    [textParking setDelegate:self];    
    textParking.keyboardType = UIKeyboardTypeDecimalPad;
    [textParking setReturnKeyType:UIReturnKeyDone];
    [textParking addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [myScrollView addSubview:textParking];
}


- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
    [self save];
}

- (IBAction)clickMainMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)clickResults:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) refresh
{
    Go_SaveAppDelegate* app = [Go_SaveAppDelegate sharedAppDelegate];
    NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
    
    NSString*   strInsurance = [NSString stringWithFormat:@"OtherCarInsurance%d", [app getSelectedCar]];
    NSString*   strCarPayment = [NSString stringWithFormat:@"OtherCarCarPayment%d", [app getSelectedCar]];
    NSString*   strMaintenance = [NSString stringWithFormat:@"OtherCarMaintenance%d", [app getSelectedCar]];
    NSString*   strCarwash = [NSString stringWithFormat:@"OtherCarCarwash%d", [app getSelectedCar]];
    NSString*   strRegistration = [NSString stringWithFormat:@"OtherCarRegistration%d", [app getSelectedCar]];
    NSString*   strParking = [NSString stringWithFormat:@"OtherCarParking%d", [app getSelectedCar]];
    
    fInsurance = [[fetchData objectForKey:strInsurance] doubleValue];
    fCarPayment = [[fetchData objectForKey:strCarPayment] doubleValue];
    fMaintenance = [[fetchData objectForKey:strMaintenance] doubleValue];
    fCarwash = [[fetchData objectForKey:strCarwash] doubleValue];
    fRegistration = [[fetchData objectForKey:strRegistration] doubleValue];
    fParking = [[fetchData objectForKey:strParking] doubleValue];
    
    double    fTotal = [self total];
    
    [textCost setText:(fTotal == 0) ? @"" : [Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", fTotal] nPlaces:2]];
    [textInsurance setText:(fInsurance == 0) ? @"" : [self realText:[NSString stringWithFormat:@"%f", fInsurance]]];
    [textCarPayment setText:(fCarPayment == 0) ? @"" : [self realText:[NSString stringWithFormat:@"%f", fCarPayment]]];
    [textMaintenance setText:(fMaintenance == 0) ? @"" : [self realText:[NSString stringWithFormat:@"%f", fMaintenance]]];
    [textCarWash setText:(fCarwash == 0) ? @"" : [self realText:[NSString stringWithFormat:@"%f", fCarwash]]];
    [textRegistration setText:(fRegistration == 0) ? @"" : [self realText:[NSString stringWithFormat:@"%f", fRegistration]]];
    [textParking setText:(fParking == 0) ? @"" : [self realText:[NSString stringWithFormat:@"%f", fParking]]];
}

- (void) save
{
    Go_SaveAppDelegate* app = [Go_SaveAppDelegate sharedAppDelegate];
    NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
    
    NSString*   strInsurance = [NSString stringWithFormat:@"OtherCarInsurance%d", [app getSelectedCar]];
    NSString*   strCarPayment = [NSString stringWithFormat:@"OtherCarCarPayment%d", [app getSelectedCar]];
    NSString*   strMaintenance = [NSString stringWithFormat:@"OtherCarMaintenance%d", [app getSelectedCar]];
    NSString*   strCarwash = [NSString stringWithFormat:@"OtherCarCarwash%d", [app getSelectedCar]];
    NSString*   strRegistration = [NSString stringWithFormat:@"OtherCarRegistration%d", [app getSelectedCar]];
    NSString*   strParking = [NSString stringWithFormat:@"OtherCarParking%d", [app getSelectedCar]];
    
    fInsurance = [textInsurance.text doubleValue];
    fCarPayment = [textCarPayment.text doubleValue];
    fMaintenance = [textMaintenance.text doubleValue];
    fCarwash = [textCarWash.text doubleValue];
    fRegistration = [textRegistration.text doubleValue];
    fParking = [textParking.text doubleValue];
    
    [fetchData setDouble:fInsurance forKey:strInsurance];
    [fetchData setDouble:fCarPayment forKey:strCarPayment];
    [fetchData setDouble:fMaintenance forKey:strMaintenance];
    [fetchData setDouble:fCarwash forKey:strCarwash];
    [fetchData setDouble:fRegistration forKey:strRegistration];
    [fetchData setDouble:fParking forKey:strParking];
}

- (double) total
{
    return fInsurance/12+fCarPayment+fMaintenance/12+fCarwash+fRegistration/12+fParking;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textCost resignFirstResponder];
    [textInsurance resignFirstResponder];
    [textCarPayment resignFirstResponder];
    [textMaintenance resignFirstResponder];
    [textCarWash resignFirstResponder];
    [textRegistration resignFirstResponder];
    [textParking resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self refreshText];
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

- (void)refreshText
{
    fInsurance = [textInsurance.text doubleValue];
    fCarPayment = [textCarPayment.text doubleValue];
    fMaintenance = [textMaintenance.text doubleValue];
    fCarwash = [textCarWash.text doubleValue];
    fRegistration = [textRegistration.text doubleValue];
    fParking = [textParking.text doubleValue];

    double    fTotal = [self total];
    [textCost setText:(fTotal == 0) ? @"" : [Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", fTotal] nPlaces:2]];
}

- (NSString*)realText:(NSString*)strOrg
{
    NSString*   strDest = strOrg;
    
    while (1) {
        NSRange    range = [strDest rangeOfString:@"."];
        if(range.length == 0)
            break;
        
        if([[strDest substringFromIndex:[strDest length]-1] isEqualToString:@"."])
        {
            strDest = [strDest substringToIndex:[strDest length]-1];
            break;
        }
        else if([[strDest substringFromIndex:[strDest length]-1] isEqualToString:@"0"])
        {
            strDest = [strDest substringToIndex:[strDest length]-1];
        }
        else
            break;
    }
    
    return strDest;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

#pragma mark TapDetectingViewDelegate methods

- (void)gotSingleTapAtPoint:(CGPoint)tapPoint {
    [textCost resignFirstResponder];
    [textInsurance resignFirstResponder];
    [textCarPayment resignFirstResponder];
    [textMaintenance resignFirstResponder];
    [textCarWash resignFirstResponder];
    [textRegistration resignFirstResponder];
    [textParking resignFirstResponder];
}

- (void)gotDoubleTapAtPoint:(CGPoint)tapPoint {
}

- (void)gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
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
