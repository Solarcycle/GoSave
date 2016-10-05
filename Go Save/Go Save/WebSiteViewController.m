//
//  WebSiteViewController.m
//  Go Save
//
//  Created by KRS on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebSiteViewController.h"


@implementation WebSiteViewController
@synthesize activityIndicator, webView;

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
    [webView release];
    [activityIndicator release];

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
    [webView setDelegate:self];
    NSString* strUrl = @"http://www.solarcyclepower.com/index/Go_Save%21.html";
    
    NSURL * url;
    url = [NSURL URLWithString:strUrl];
    
	[self.webView setScalesPageToFit:YES];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];

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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	self.activityIndicator.hidden = NO;
	[self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	self.activityIndicator.hidden = YES;
	[self.activityIndicator stopAnimating];
	[self.webView setScalesPageToFit:YES];
}

- (IBAction)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
