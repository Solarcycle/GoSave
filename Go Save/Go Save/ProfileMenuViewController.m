//
//  ProfileMenuViewController.m
//  Go Save
//
//  Created by KRS on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Go_SaveAppDelegate.h"
#import "ProfileMenuViewController.h"
#import "InputCarViewController.h"
#import "WebSiteViewController.h"


@implementation ProfileMenuViewController

@synthesize carTable;
@synthesize inputViewController, websiteViewController;
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
    [websiteViewController release];
    [inputViewController release];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    banner.delegate = nil;
    banner = nil;

    if(banner == nil)
        [self createADBannerView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [curTextField resignFirstResponder];
	Go_SaveAppDelegate *app = [Go_SaveAppDelegate sharedAppDelegate];
    [app setSelectedCar:indexPath.row];

    [self.navigationController pushViewController:inputViewController animated:YES];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
    
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
        if([subView isKindOfClass:[UITextField class]])
            [subView removeFromSuperview];
        if([subView isKindOfClass:[UIButton class]])
            [subView removeFromSuperview];
    }

    tableView.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; 
    
    UIImageView*    myImageArrow = [[UIImageView alloc] initWithFrame:CGRectMake(270, 20, 22, 19)];
    [myImageArrow setImage:[UIImage imageNamed:@"Arrow.png"]];
    [cell addSubview:myImageArrow];
    
    UIImageView*    myBtn = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, 50)];
    [myBtn setImage:[UIImage imageNamed:@"AddImage.png"]];
    [cell addSubview:myBtn];

    NSString*   strCarName = [NSString stringWithFormat:@"CarName%d", indexPath.row];
    NSString*   strCarImage = [NSString stringWithFormat:@"CarImage%d", indexPath.row];
    
    UITextField*    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 20, 150, 30)];
    if ([fetchData objectForKey:strCarName]) 
    {
        NSString*   strSavedCarName = (NSString*)[fetchData objectForKey:strCarName];
        [myTextField setText:strSavedCarName];
    }
    else
    {
        [myTextField setText:@"Input Car Name"];
    }
    
    myTextField.tag = indexPath.row;
    [myTextField setDelegate:self];    
    [myTextField setReturnKeyType:UIReturnKeyDone];
    [myTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [cell addSubview:myTextField];

    UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(20, 5, 50, 50)];

    if ([fetchData objectForKey:strCarImage]) 
    {
        NSData* pngData = [fetchData objectForKey:strCarImage];
        UIImage *imgNormal = [UIImage imageWithData:pngData];
        [button setBackgroundImage:imgNormal forState:UIControlStateNormal];
    }
    else
    {
        UIImage *imgNormal = [UIImage imageNamed:@"AddImage.png"];
        [button setBackgroundImage:imgNormal forState:UIControlStateNormal];
    }

    btnCar[indexPath.row] = [button retain];
    [button setTag:indexPath.row];
    [cell  addSubview: button];
    [button addTarget:self action:@selector(addImage:) forControlEvents: UIControlEventTouchUpInside];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        nDeleteCar = indexPath.row;
        [self alert];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder]; 
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
    
    NSString*   strCarImage = [NSString stringWithFormat:@"CarName%d", textField.tag];
    [fetchData setObject:textField.text forKey:strCarImage];
}

- (IBAction)addImage:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    nSelectedImage = btn.tag;
    
    if(btn.tag == 0)
    {
    }

	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo Source"
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
													otherButtonTitles:@"Photo Library", @"Camera", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.delegate=self;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)sheet clickedButtonAtIndex:(NSInteger)button
{
    UIImagePickerControllerSourceType sourceType;
    
    if ( button == 0 ) {//photo library
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if ( button == 1 ) {//camera
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        [sheet dismissWithClickedButtonIndex:button animated:YES];		
        return;
    }

    if ([UIImagePickerController isSourceTypeAvailable:sourceType]){
        UIImagePickerController*    picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:sourceType];
        [picker setDelegate:self];
        [self presentModalViewController:picker animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Camera" message:@"Please install camera to use this feature" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }		

	[sheet dismissWithClickedButtonIndex:button animated:YES];		
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker 
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    NSData * data = UIImagePNGRepresentation(image);
    NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
    
    NSString*   strCarImage = [NSString stringWithFormat:@"CarImage%d", nSelectedImage];
    [fetchData setObject:data forKey:strCarImage];
    
    [picker dismissModalViewControllerAnimated:YES];
    
    [btnCar[nSelectedImage] setBackgroundImage:image forState:UIControlStateNormal];
}

- (IBAction)goWeb:(id)sender
{
    [self.navigationController pushViewController:websiteViewController animated:YES];
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
    frame.origin = CGPointMake(0.0f, CGRectGetMaxY(self.view.bounds)-frame.size.height);
    
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

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [curTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    curTextField = textField;
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

-(void) keyboardWillShow:(NSNotification *) note
{
	[self animateTextField: self.view up: YES]; 
}

-(void) keyboardWillHide:(NSNotification *) note
{
	[self animateTextField: self.view up: NO]; 
}

- (void) animateTextField: (UIView*) textField up: (BOOL) up {
	const int movementDistance = 60; // tweak as needed     
	const float movementDuration = 0.3f; // tweak as needed      
	int movement = (up ? -movementDistance : movementDistance);      
	[UIView beginAnimations: @"anim" context: nil];     
	[UIView setAnimationBeginsFromCurrentState: YES];     
	[UIView setAnimationDuration: movementDuration];     
	self.view.frame = CGRectOffset(self.view.frame, 0, movement);     
	[UIView commitAnimations]; 
}

- (void) alert {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure you want to delete this data? All driving behavior and car cost data will be lost."
												   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([alertView.title isEqualToString:@"Warning"] == NO)
        return;

	Go_SaveAppDelegate *app = [Go_SaveAppDelegate sharedAppDelegate];
    
    if(buttonIndex == 1)
    {
        NSUserDefaults *fetchData=[NSUserDefaults standardUserDefaults];
        NSString*   strCarName = [NSString stringWithFormat:@"CarName%d", nDeleteCar];
        NSString*   strCarImage = [NSString stringWithFormat:@"CarImage%d", nDeleteCar];
        
        NSString*   strBussPass = [NSString stringWithFormat:@"BusPass%d", [app getSelectedCar]];
        NSString*   strLightRailPass = [NSString stringWithFormat:@"LightRailPass%d", [app getSelectedCar]];
        NSString*   strTrainPass = [NSString stringWithFormat:@"TrainPass%d", [app getSelectedCar]];
        NSString*   strSubwayPass = [NSString stringWithFormat:@"SubwayPass%d", [app getSelectedCar]];
        NSString*   strTaxi = [NSString stringWithFormat:@"Taxi%d", [app getSelectedCar]];
        NSString*   strRentalCar = [NSString stringWithFormat:@"RentalCar%d", [app getSelectedCar]];
        NSString*   strDistance = [NSString stringWithFormat:@"DistanceFromHome%d", [app getSelectedCar]];
        
        NSString*   strInsurance = [NSString stringWithFormat:@"OtherCarInsurance%d", [app getSelectedCar]];
        NSString*   strCarPayment = [NSString stringWithFormat:@"OtherCarCarPayment%d", [app getSelectedCar]];
        NSString*   strMaintenance = [NSString stringWithFormat:@"OtherCarMaintenance%d", [app getSelectedCar]];
        NSString*   strCarwash = [NSString stringWithFormat:@"OtherCarCarwash%d", [app getSelectedCar]];
        NSString*   strRegistration = [NSString stringWithFormat:@"OtherCarRegistration%d", [app getSelectedCar]];
        NSString*   strParking = [NSString stringWithFormat:@"OtherCarParking%d", [app getSelectedCar]];

        [fetchData removeObjectForKey:strCarName];
        [fetchData removeObjectForKey:strCarImage];
        
        [fetchData removeObjectForKey:strBussPass];
        [fetchData removeObjectForKey:strLightRailPass];
        [fetchData removeObjectForKey:strTrainPass];
        [fetchData removeObjectForKey:strSubwayPass];
        [fetchData removeObjectForKey:strTaxi];
        [fetchData removeObjectForKey:strRentalCar];
        [fetchData removeObjectForKey:strDistance];
        
        [fetchData removeObjectForKey:strInsurance];
        [fetchData removeObjectForKey:strCarPayment];
        [fetchData removeObjectForKey:strMaintenance];
        [fetchData removeObjectForKey:strCarwash];
        [fetchData removeObjectForKey:strRegistration];
        [fetchData removeObjectForKey:strParking];
        
        [app deleteCar:nDeleteCar];
        [carTable reloadData];
    }
}

@end
