//
//  ResultViewController.m
//  Go Save
//
//  Created by KRS on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Go_SaveAppDelegate.h"
#import "ResultViewController.h"
#import "GoScreenViewController.h"

@implementation ResultViewController
@synthesize myScrollView, goScreenViewController, tapView;;
@synthesize labelMPG, labelNonWorkMilesPerDay, labelDistanceToWork, labelCarPaymentPerMonth, labelDollarPerGal;
@synthesize sldMPG, sldNonWorkMilesPerDay, sldDistanceToWork, sldCarPaymentPerMonth, sldDollarPerGal;
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
    
    [goScreenViewController release];
    [labelMPG release];
    [labelNonWorkMilesPerDay release];
    [labelDistanceToWork release];
    [labelCarPaymentPerMonth release];
    [labelDollarPerGal release];
    
    [sldMPG release];
    [sldNonWorkMilesPerDay release];
    [sldDistanceToWork release];
    [sldCarPaymentPerMonth release];
    [sldDollarPerGal release];
    
    banner.delegate = nil;
    [banner release]; banner = nil;

    [tapView release];

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
    [myScrollView setContentSize:CGSizeMake(320, 500)];
    [self addTextField];
    [super viewDidLoad];

//    Go_SaveAppDelegate *app = [Go_SaveAppDelegate sharedAppDelegate];
//    aryFillUp = [app readFillData:[app getSelectedCar]];
    
    // Do any additional setup after loading the view from its nib.
    banner.delegate = nil;
    banner = nil;
    
    if(banner == nil)
        [self createADBannerView];
    
    [self load];
    [self calc];
}

- (void)viewDidUnload
{
    [self save];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    if(animated == NO)
        [self.navigationController popViewControllerAnimated:NO];
    else
    {
//        Go_SaveAppDelegate *app = [Go_SaveAppDelegate sharedAppDelegate];
//        aryFillUp = [app readFillData:[app getSelectedCar]];
        
        [self calc];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self save];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setData:(NSArray*)array
{
    aryFillUp = array;
}

- (void) addTextField {
    textCarTotal = [[UITextField alloc] initWithFrame:CGRectMake(30, 62, 100, 39)];
    textCarTotal.tag = 0;
    [textCarTotal setEnabled:NO];    
    [textCarTotal setTextAlignment:UITextAlignmentCenter];
    [textCarTotal setDelegate:self];    
    textCarTotal.keyboardType = UIKeyboardTypeDecimalPad;
    [textCarTotal setReturnKeyType:UIReturnKeyDone];
    [textCarTotal addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:textCarTotal];

    textFuelCost = [[UITextField alloc] initWithFrame:CGRectMake(190, 62, 100, 39)];
    textFuelCost.tag = 1;
    [textFuelCost setEnabled:NO];    
    [textFuelCost setTextAlignment:UITextAlignmentCenter];
    [textFuelCost setDelegate:self];    
    textFuelCost.keyboardType = UIKeyboardTypeDecimalPad;
    [textFuelCost setReturnKeyType:UIReturnKeyDone];
    [textFuelCost addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:textFuelCost];

    textWorkMilesPerFill = [[UITextField alloc] initWithFrame:CGRectMake(30, 132, 100, 39)];
    textWorkMilesPerFill.tag = 2;
    [textWorkMilesPerFill setEnabled:NO];    
    [textWorkMilesPerFill setTextAlignment:UITextAlignmentCenter];
    [textWorkMilesPerFill setDelegate:self];    
    textWorkMilesPerFill.keyboardType = UIKeyboardTypeDecimalPad;
    [textWorkMilesPerFill setReturnKeyType:UIReturnKeyDone];
    [textWorkMilesPerFill addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:textWorkMilesPerFill];

    textDaysPerFill = [[UITextField alloc] initWithFrame:CGRectMake(190, 132, 100, 39)];
    textDaysPerFill.tag = 3;
    [textDaysPerFill setEnabled:NO];    
    [textDaysPerFill setTextAlignment:UITextAlignmentCenter];
    [textDaysPerFill setDelegate:self];    
    textDaysPerFill.keyboardType = UIKeyboardTypeDecimalPad;
    [textDaysPerFill setReturnKeyType:UIReturnKeyDone];
    [textDaysPerFill addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:textDaysPerFill];
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder]; 
}

- (IBAction)clickMainMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)clickFillUpData:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickReset:(id)sender
{
    [textCarTotal setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", f] nPlaces:2]];
    [textFuelCost setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", t] nPlaces:2]];
    [textWorkMilesPerFill setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", e] nPlaces:0]];
    [textDaysPerFill setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", q] nPlaces:0]];
    
    [sldMPG setValue:b];
    [sldNonWorkMilesPerDay setValue:1];
    [sldDistanceToWork setValue:j];
    [sldCarPaymentPerMonth setValue:y];
    [sldDollarPerGal setValue:1];

    [labelMPG setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", sldMPG.value] nPlaces:1]];
    [labelNonWorkMilesPerDay setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", sldNonWorkMilesPerDay.value*z] nPlaces:1]];
    [labelDistanceToWork setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", sldDistanceToWork.value] nPlaces:2]];
    [labelCarPaymentPerMonth setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", sldCarPaymentPerMonth.value] nPlaces:2]];
    [labelDollarPerGal setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", sldDollarPerGal.value] nPlaces:2]];
}

- (IBAction)clickGoScreen:(id)sender
{
    [goScreenViewController setData:f F1:[textCarTotal.text doubleValue] C:c C1:[labelDollarPerGal.text doubleValue] Z:z Z1:[labelNonWorkMilesPerDay.text doubleValue] B: b B1:[labelMPG.text doubleValue] S:s S1:s OtherCarCost:u OtherCarCost1:u];
    [self.navigationController pushViewController:goScreenViewController animated:YES];
}

- (void)calc
{
    Go_SaveAppDelegate *app = [Go_SaveAppDelegate sharedAppDelegate];
    NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
    NSString*   strDistance = [NSString stringWithFormat:@"DistanceFromHome%d", [app getSelectedCar]];
    
    NSString*   strInsurance = [NSString stringWithFormat:@"OtherCarInsurance%d", [app getSelectedCar]];
    NSString*   strCarPayment = [NSString stringWithFormat:@"OtherCarCarPayment%d", [app getSelectedCar]];
    NSString*   strMaintenance = [NSString stringWithFormat:@"OtherCarMaintenance%d", [app getSelectedCar]];
    NSString*   strCarwash = [NSString stringWithFormat:@"OtherCarCarwash%d", [app getSelectedCar]];
    NSString*   strRegistration = [NSString stringWithFormat:@"OtherCarRegistration%d", [app getSelectedCar]];
    NSString*   strParking = [NSString stringWithFormat:@"OtherCarParking%d", [app getSelectedCar]];
    
    fInsurance = [fetchData doubleForKey:strInsurance];
    fCarPayment = [fetchData doubleForKey:strCarPayment];
    fMaintenance = [fetchData doubleForKey:strMaintenance];
    fCarwash = [fetchData doubleForKey:strCarwash];
    fRegistration = [fetchData doubleForKey:strRegistration];
    fParking = [fetchData doubleForKey:strParking];
    
    int n = [aryFillUp count];
    if(n == 0)
        return;
    j = [fetchData floatForKey:strDistance];
    p = 0;
    c = 0;
    w = 0;
    d = 0;
    e = 0;
    q = 0;
    s = 0;
    m1 = 0, m2 = 0;
    w1 = 0, w2 = 0;
    z = 0;
    d1 = 0, d2 = 0;
    b = 0;
    t = 0;
    a = 0;
    
    
    NSNumber* prevDate = nil;
    NSNumber* prevOdometer = nil;
    
    for(int i = 0; i < n; i++)
    {
        NSDictionary*   dict = [aryFillUp objectAtIndex:i];

        NSNumber* date = [dict objectForKey:@"Date"];
        NSNumber* odometer = [dict objectForKey:@"Odometer"];
        NSNumber* daysWorked = [dict objectForKey:@"DaysWorked"];
        NSNumber* perGallon = [dict objectForKey:@"PerGallon"];
        NSNumber* gallons = [dict objectForKey:@"Gallons"];

        p += [perGallon floatValue];
        float mi = 0;
        float gi = [gallons floatValue];
        
        if(i != 0)
        {
            w += [daysWorked intValue];
            d += ([date intValue] - [prevDate intValue])/(24*60*60);
            mi = [odometer floatValue] - [prevOdometer floatValue];
        }

        a += mi;
        if(gi == 0)
            gi = 1;
        b += mi/gi;

        m1 = mi;
        d1 = ([date intValue] - [prevDate intValue])/(24*60*60);
        w1 = [daysWorked intValue];
        
        if(i == 0)
        {
        }
        else
        {
            z += (m1-2*j*w1)/d1;
        }
        
        prevDate = date;
        prevOdometer = odometer;
    }
    
    n = n-1;
    a = a/n;
    c = p/(n+1); // Average cost per gallon
    e = w/n;
    q = (float)d/(float)n;
    s = e/q;
    z = z/n;
    b = b/n;
    if(b == 0)
        b = 1;
    t = (30*c*(2*s*j+z))/b;
    u = fInsurance/12 + fMaintenance/12 + fRegistration/12 + fCarPayment + fCarwash + fParking;
    
    f = t+u;
    h = a/(2*s*j + f*z);
    
    y = fCarPayment;
    
    fTotalOtherCost = fInsurance/12 + fCarPayment + fMaintenance/12 + fCarwash + fRegistration/12 + fParking;
    fTotal = fTotalOtherCost + t;
    
    [textCarTotal setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", f] nPlaces:2]];
    [textFuelCost setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", t] nPlaces:2]];
    [textWorkMilesPerFill setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", e] nPlaces:0]];
    [textDaysPerFill setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", q] nPlaces:0]];
    
    [sldMPG setMinimumValue:5]; [sldMPG setMaximumValue:100]; [sldMPG setValue:b]; 
    [labelMPG setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", b] nPlaces:1]];
    
    [sldNonWorkMilesPerDay setMinimumValue:0]; [sldNonWorkMilesPerDay setMaximumValue:2]; [sldNonWorkMilesPerDay setValue:1];
    [labelNonWorkMilesPerDay setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", z] nPlaces:1]];

    [sldDistanceToWork setMinimumValue:1]; [sldDistanceToWork setMaximumValue:60]; [sldDistanceToWork setValue:j];
    [labelDistanceToWork setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", j] nPlaces:2]];
    
    [sldCarPaymentPerMonth setMinimumValue:0]; [sldCarPaymentPerMonth setMaximumValue:1000]; [sldCarPaymentPerMonth setValue:y];
    [labelCarPaymentPerMonth setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", y] nPlaces:2]];

    [sldDollarPerGal setMinimumValue:c]; [sldDollarPerGal setMaximumValue:10]; [sldDollarPerGal setValue:c];
    [labelDollarPerGal setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", c] nPlaces:2]];
}

- (IBAction)clickSldMPG:(id)sender
{
    [self adjust];
}

- (IBAction)clickSldNonwork:(id)sender
{
    [self adjust];
}

- (IBAction)clickSldDistance:(id)sender
{
    [self adjust];
}

- (IBAction)clickSldCarPayment:(id)sender
{
    [self adjust];
}

- (IBAction)clickSldDollarPerGal:(id)sender
{
    [self adjust];
}


- (void)adjust
{
    float b1 = sldMPG.value;
    float j1 = sldDistanceToWork.value;
    float z1 = sldNonWorkMilesPerDay.value;
    float y1 = sldCarPaymentPerMonth.value;
    float c1 = sldDollarPerGal.value;
    
    float t1 = (30*c1*(2*s*j1+z1*z))/b1;
    float u1 = fInsurance/12 + fMaintenance/12 + fRegistration/12 + fCarwash + fParking + y1;
    
    float f1 = t1+u1;
    float h1 = a*b1/((2*s*j1 + z*z1)*b);
    float W1 = s*h1;
    
//    float fTotalOtherCost1 = fInsurance/12 + y1 + fMaintenance/12 + fCarwash + fRegistration/12 + fParking;
//    float fTotal1 = fTotalOtherCost1 + t1;
    
    [textCarTotal setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", f1] nPlaces:2]];
    [textFuelCost setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", t1] nPlaces:2]];
    [textWorkMilesPerFill setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", W1] nPlaces:0]];
    [textDaysPerFill setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", h1] nPlaces:0]];

    [labelMPG setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", sldMPG.value] nPlaces:1]];
    [labelNonWorkMilesPerDay setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", z*z1] nPlaces:1]];
    [labelDistanceToWork setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", sldDistanceToWork.value] nPlaces:2]];
    [labelCarPaymentPerMonth setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", sldCarPaymentPerMonth.value] nPlaces:2]];
    [labelDollarPerGal setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", sldDollarPerGal.value] nPlaces:2]];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string 
{
    int nDecimalCount = 3;
    
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


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textCarTotal resignFirstResponder];
    [textFuelCost resignFirstResponder];
    [textWorkMilesPerFill resignFirstResponder];
    [textDaysPerFill resignFirstResponder];
}

#pragma mark TapDetectingViewDelegate methods

- (void)gotSingleTapAtPoint:(CGPoint)tapPoint {
    [textCarTotal resignFirstResponder];
    [textFuelCost resignFirstResponder];
    [textWorkMilesPerFill resignFirstResponder];
    [textDaysPerFill resignFirstResponder];
}

- (void)gotDoubleTapAtPoint:(CGPoint)tapPoint {
}

- (void)gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
}

- (void) load
{
    Go_SaveAppDelegate *app = [Go_SaveAppDelegate sharedAppDelegate];
    NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
    NSString*   strDollarPerGal = [NSString stringWithFormat:@"DollarPerGal%d", [app getSelectedCar]];
    
    if([fetchData objectForKey:strDollarPerGal])
        y = [[fetchData objectForKey:strDollarPerGal] doubleValue];
    else
        y = 300;
}

- (void) save
{
    Go_SaveAppDelegate *app = [Go_SaveAppDelegate sharedAppDelegate];
    NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
    NSString*   strDollarPerGal = [NSString stringWithFormat:@"DollarPerGal%d", [app getSelectedCar]];
    
    [fetchData setDouble:sldDollarPerGal.value forKey:strDollarPerGal];
}


@end
