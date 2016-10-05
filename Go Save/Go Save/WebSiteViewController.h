//
//  WebSiteViewController.h
//  Go Save
//
//  Created by KRS on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebSiteViewController : UIViewController<UIWebViewDelegate> {
    
}

@property (nonatomic,retain) 	IBOutlet UIActivityIndicatorView * activityIndicator;
@property (nonatomic,retain) 	IBOutlet UIWebView * webView;

- (IBAction)clickBack:(id)sender;

@end
