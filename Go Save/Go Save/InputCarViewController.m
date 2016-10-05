//
//  InputCarViewController.m
//  Go Save
//
//  Created by KRS on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputCarViewController.h"
#import "Go_SaveAppDelegate.h"
#import "FillUpViewController.h"
#import "OtherCarCostViewController.h"
#import "ResultViewController.h"


@implementation InputCarViewController

@synthesize fillupViewController, fillTable, otherCarCostViewController, resultViewController, btnResults, myScrollView;
@synthesize banner, labelCarName;

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
    [fillupViewController release];
    [fillTable release];
    [otherCarCostViewController release];
    [resultViewController release];
    [btnResults release];
    [myScrollView release];
    [labelCarName release];
    
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
    [super viewDidLoad];

    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(230, 75, 70, 30)];

    [myTextField setTextAlignment:UITextAlignmentCenter];
    [myTextField setDelegate:self];
    myTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [myTextField setReturnKeyType:UIReturnKeyDone];
    [myTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    Go_SaveAppDelegate *app = [Go_SaveAppDelegate sharedAppDelegate];
    
    NSString*   strDistance = [NSString stringWithFormat:@"DistanceFromHome%d", [app getSelectedCar]];
    NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
    float fDistance = [fetchData floatForKey:strDistance];
    if(fDistance != 0)
        [myTextField setText:[Go_SaveAppDelegate realText:[NSString stringWithFormat:@"%f", fDistance]]];

    [self.view addSubview:myTextField];

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

- (int)getValidDataCount
{
    int nCount = 0;
    for(int i = 0; i < [aryFillUp count]; i++)
    {
        if([self isValidFillData:i])
            nCount++;
    }
    
    return nCount;
}

-(void)viewWillAppear:(BOOL)animated 
{
    if(animated)
    {
        Go_SaveAppDelegate *app = [Go_SaveAppDelegate sharedAppDelegate];
        aryFillUp = [app readFillData:[app getSelectedCar]];
        [fillTable reloadData];
//        if([self getValidDataCount] >=3)
//            [btnResults setEnabled:YES];
//        else
//            [btnResults setEnabled:NO];
        
        CGPoint bottomOffset = CGPointMake(0, MAX(0,[myScrollView contentSize].height-[myScrollView frame].size.height)); 

        NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
        NSString*   strCarName = [NSString stringWithFormat:@"CarName%d", [app getSelectedCar]];
        
        if ([fetchData objectForKey:strCarName]) 
        {
            NSString*   strSavedCarName = (NSString*)[fetchData objectForKey:strCarName];
            [labelCarName setText:strSavedCarName];
        }
        else
        {
            [labelCarName setText:@""];
        }

        NSString*   strDistance = [NSString stringWithFormat:@"DistanceFromHome%d", [app getSelectedCar]];
        float fDistance = [fetchData floatForKey:strDistance];
        if(fDistance != 0)
            [myTextField setText:[Go_SaveAppDelegate realText:[NSString stringWithFormat:@"%f", fDistance]]];
        else
            [myTextField setText:@""];

        [myScrollView setContentOffset: bottomOffset animated: YES]; 
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder]; 
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == [aryFillUp count]-1)
        return YES;
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self alert];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(aryFillUp == nil || indexPath.row >= [aryFillUp count])
    {
        [fillupViewController setData:indexPath.row ary:aryFillUp date:-1 odometer:-1 daysWorked:-1 perGallon:-1 gallons:-1 key:-1 isNew:YES];
    }
    else
    {
        NSDictionary* dict = [aryFillUp objectAtIndex:indexPath.row];
        
        NSNumber* date = [dict objectForKey:@"Date"];
        NSNumber* odometer = [dict objectForKey:@"Odometer"];
        NSNumber* daysWorked = [dict objectForKey:@"DaysWorked"];
        NSNumber* perGallon = [dict objectForKey:@"PerGallon"];
        NSNumber* gallons = [dict objectForKey:@"Gallons"];
        NSNumber* key = [dict objectForKey:@"no"];

        [fillupViewController setData:indexPath.row ary:aryFillUp date:[date intValue] odometer:[odometer doubleValue] daysWorked:[daysWorked intValue] perGallon:[perGallon doubleValue] gallons:[gallons doubleValue] key:[key intValue] isNew:NO];
    }

    [self.navigationController pushViewController:fillupViewController animated:YES];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 40;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MIN(10, [aryFillUp count]+1);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellIndentifer=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
	if (cell == nil) {
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
    }
    
    NSArray *subviews = cell.subviews;
    for(int i = [subviews count]-1; i >=0 ; i--)
    {
        UIView* subView = [subviews objectAtIndex:i];
        if([subView isKindOfClass:[UILabel class]])
            [subView removeFromSuperview];
        if([subView isKindOfClass:[UIImageView class]])
            [subView removeFromSuperview];
    }

    tableView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    
    UIImageView*    myImageArrow = [[UIImageView alloc] initWithFrame:CGRectMake(290, 10, 22, 19)];
    [myImageArrow setImage:[UIImage imageNamed:@"Arrow.png"]];
    [cell addSubview:myImageArrow];
    
    UIImageView*    myBtn = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 44, 41)];
    if([self isValidFillData:indexPath.row])
        [myBtn setImage:[UIImage imageNamed:@"Tick.png"]];
    else
        [myBtn setImage:[UIImage imageNamed:@"Cross.png"]];
    
    if(indexPath.row < [aryFillUp count])
        [cell addSubview:myBtn];
    
    UILabel*    label = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 150, 30)];
    [label setText:[NSString stringWithFormat:@"Fill-Up #%d - ", indexPath.row+1]];
    label.font=[label.font fontWithSize:18];
    [cell addSubview:label];
    
    if(indexPath.row < [aryFillUp count])
    {
        NSDictionary*   dict = [aryFillUp objectAtIndex:indexPath.row];
        NSNumber*       minDate = [dict objectForKey:@"Date"];
        
        NSDate*         date = [NSDate dateWithTimeIntervalSince1970: [minDate intValue]];
        
        NSLocale *uslocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]; 
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init]; 
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;     
        NSDateComponents *components = [calendar components:units fromDate:date];
        
        NSArray* weekArray = [dateFormatter shortWeekdaySymbols];
        NSArray* monthArray = [dateFormatter shortMonthSymbols];
        
        int nWeekDay = [components weekday];
        int nMonth = [components month];
        
        
        NSString*   strDate = [NSString stringWithFormat:@"%@ %@ %d", [weekArray objectAtIndex:nWeekDay-1], [monthArray objectAtIndex:nMonth-1], [components day]];

        UILabel*    label = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 125, 30)];
        label.font=[label.font fontWithSize:16];
        [label setText:strDate];
        [cell addSubview:label];
        
        [dateFormatter setLocale:uslocale]; 
        [uslocale release];
    }
    else
    {
        UILabel*    label = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 120, 30)];
        label.font=[label.font fontWithSize:16];
        [label setText:@"Empty"];
        [cell addSubview:label];
    }

    return cell;
}

- (BOOL)isValidFillData:(int)nIndx {
    if(aryFillUp == nil)
        return NO;
    
    if(nIndx >= [aryFillUp count])
        return NO;
    
    NSDictionary* dict = [aryFillUp objectAtIndex:nIndx];
    
    NSNumber* carNo = [dict objectForKey:@"CarNo"];
    if(carNo == nil)
        return NO;
    
    NSNumber* date = [dict objectForKey:@"Date"];
    NSNumber* odometer = [dict objectForKey:@"Odometer"];
    NSNumber* daysWorked = [dict objectForKey:@"DaysWorked"];
    NSNumber* perGallon = [dict objectForKey:@"PerGallon"];
    NSNumber* gallons = [dict objectForKey:@"Gallons"];

    if([date intValue] == -1)
        return NO;
    if([odometer doubleValue] == -1)
        return NO;
    if([daysWorked doubleValue] == -1)
        return NO;
    if([perGallon doubleValue] == -1)
        return NO;
    if([gallons doubleValue] == -1)
        return NO;
    
    if(nIndx == 0)
    {
        if([odometer doubleValue] == 0)
            return NO;
        if([perGallon doubleValue] == 0)
            return NO;
    }
    else
    {
        if([odometer doubleValue] == 0)
            return NO;
//        if([daysWorked doubleValue] == 0)
//            return NO;
        if([perGallon doubleValue] == 0)
            return NO;
        if([gallons doubleValue] == 0)
            return NO;
    }
    
    return YES;
}

- (IBAction)otherCarCost:(id)sender
{
    [self.navigationController pushViewController:otherCarCostViewController animated:YES];
}

- (IBAction)clickMainMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickResult:(id)sender
{
    if([self getValidDataCount] < 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Three Fill-Ups required for Results calculations. Please enter more Fill-Up data."
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
        
        return;
    }

    NSMutableArray*    array = [[NSMutableArray alloc] initWithCapacity:1];
    for(int i = 0; i < [aryFillUp count]; i++)
    {
        if([self isValidFillData:i])
            [array addObject:[aryFillUp objectAtIndex:i]];
    }
    
    [resultViewController setData:array];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [myTextField resignFirstResponder];
}

- (void)save
{
    NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
    
    Go_SaveAppDelegate *app = [Go_SaveAppDelegate sharedAppDelegate];

    NSString*   strDistance = [NSString stringWithFormat:@"DistanceFromHome%d", [app getSelectedCar]];
    [fetchData setFloat:[myTextField.text floatValue] forKey:strDistance];
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
    frame.origin = CGPointMake(0.0f, 0.0f);
    
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
    [self.view addSubview:bannerView];
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

- (void) alert {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure you want to delete this Fill-Up Data?\n Data will be lost."
												   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([aryFillUp count] == 0)
        return;
    
    if([alertView.title isEqualToString:@"Warning"] == NO)
        return;
    
	Go_SaveAppDelegate *app = [Go_SaveAppDelegate sharedAppDelegate];
    
    if(buttonIndex == 1)
    {
        int nIndx = [aryFillUp count] - 1;
        NSDictionary* dict = [aryFillUp objectAtIndex:nIndx];
        NSNumber* key = [dict objectForKey:@"no"];
        
        [app removeFillData:[key intValue]];
        
        aryFillUp = [app readFillData:[app getSelectedCar]];
        [fillTable reloadData];
    }
}

@end
