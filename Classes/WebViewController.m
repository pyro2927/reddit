//
//  ViewAController.m
//  ViewPusher
//
//  Created by Alexander Sommer on 27.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//#import "RootViewController.h"
#import "WebViewController.h"
#define INDICATOR_VIEW	999



@implementation WebViewController
@synthesize navigationController;
@synthesize webView;
@synthesize url;

// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
	// Add desired webview
	webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[webView setScalesPageToFit:YES];
	self.view=webView;
	NSLog(@"Webview Loaded");
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

-(void)loadPage:(NSURLRequest *)requestedURL{
	url=requestedURL;
	[webView loadRequest:url];
	NSLog(@"URL Loaded");
	[webView setScalesPageToFit:YES];
	self.view=webView;
	NSLog(@"loadPage successfully Loaded");
}
-(void)threadedLoad{
	NSLog(@"threadedLoad started");
	NSAutoreleasePool *webpool = [[NSAutoreleasePool alloc] init];
	NSLog(@"webpool created");
	[webView loadRequest:url];
	NSLog(@"URL Loaded");
	self.view=webView;
	[webpool release];
	NSLog(@"threadedLoad completed");
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (YES);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

@end

