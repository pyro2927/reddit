//
//  WebViewController.h
//  
//
//  Created by Joe Pintozzi on 27.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController {

	IBOutlet UINavigationController *navigationController;
	IBOutlet UIWebView *webView;
	NSURLRequest *url;
	
}

@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSURLRequest *url;
-(void)loadView:(NSURLRequest *)requestedURL;
-(void)loadPage:(NSURLRequest *)requestedURL;
@end
