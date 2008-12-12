//
//  SavedView.h
//  reddit
//
//  Created by Joseph Pintozzi on 11/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SavedView : UITableViewController {
	IBOutlet UITableView * newsTable;
	IBOutlet UIWebView *webView;
	IBOutlet UINavigationController *navigationController, *reddit;
	NSURLRequest *request;
	UIActivityIndicatorView * activityIndicator;
	CGSize cellSize;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	// it parses through the document, from top to bottom...
	// we collect and cache each sub-element value, and then save each item to our array.
	// we use these to track each current item, until it's ready to be added to the "stories" array
	NSString * currentElement, *comments, *path, *plistPath;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink, * currentUser;
	NSArray *savedStories;
	NSDictionary *selection;
}
@property (nonatomic, retain) UINavigationController *navigationController, *reddit;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) NSString *path, *plistPath;
@property (nonatomic, retain) NSArray *savedStories;
@property (nonatomic, retain) NSDictionary *selection;
- (IBAction)pushWebViewMethod:(id)sender;
- (void)parseXMLFileAtURL:(NSString *)URL;
@end
