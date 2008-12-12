//
//  redditAppDelegate.m
//  reddit
//
//  Created by Joseph Pintozzi on 10/27/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "redditAppDelegate.h"
#import "redditSelector.h"
#import "TextViewController.h"

@implementation redditAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize reddit;
@synthesize path;
@synthesize saved;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//Create file needed
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"path.plist"];	
	NSDictionary *settingsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:	@"http://www.reddit.com/.rss",@"reddit",nil] forKeys:[NSArray arrayWithObjects:	@"path",@"title",nil]];
	[settingsDict writeToFile:finalPath atomically:YES];
	finalPath = [documentsDirectory stringByAppendingPathComponent:@"saved.plist"];
	NSArray *savedStories=[NSArray arrayWithContentsOfFile:finalPath];
	NSLog(@"Number of stories: %d",[savedStories count]);
	if([savedStories count]==0){
		NSLog(@"Saved stories copied over");
		NSString *savedPath = [bundlePath stringByAppendingPathComponent:@"saved.plist"];
		[[NSArray arrayWithContentsOfFile:savedPath] writeToFile:finalPath atomically:YES];
	}
	NSString *filePath = [bundlePath stringByAppendingPathComponent:@"reddit_tab.png"];
	// Create the array of UIViewControllers
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	//add navigation controller
	[controllers addObject:navigationController];
	navigationController.title=@"reddit";
	[navigationController.tabBarItem initWithTitle:@"reddit" image:[UIImage imageWithContentsOfFile:filePath] tag:0];
	//NSLog(@"Path: %@",[navigationController getPath]);
	//create selector screen
	redditSelector *rSelector = [[redditSelector alloc] init];
	rSelector.parent=self;
	//add selector screen
	[controllers addObject:rSelector];
	rSelector.title=@"subreddit";
	filePath = [bundlePath stringByAppendingPathComponent:@"subreddit_tab.png"];
	[rSelector.tabBarItem initWithTitle:@"subreddit" image:[UIImage imageWithContentsOfFile:filePath] tag:0];
	//create and add saved articles screen
	SavedView *savedTable = [[SavedView alloc]init];
	UINavigationController *savedNavController = [[[UINavigationController alloc] initWithRootViewController:savedTable] autorelease];
	savedTable.navigationController=savedNavController;
	NSLog(@"Adding saved view controller");
	[controllers addObject:savedNavController];
	NSLog(@"Saved view controller successfully added");
	savedNavController.title=@"saved";
	filePath = [bundlePath stringByAppendingPathComponent:@"floppy.png"];
	[savedNavController.tabBarItem initWithTitle:@"saved" image:[UIImage imageWithContentsOfFile:filePath] tag:0];
	
	
	
	//create help screen
	TextViewController *infoPage = [[TextViewController alloc] init];
	[controllers addObject:infoPage];
	infoPage.title=@"info";
	filePath = [bundlePath stringByAppendingPathComponent:@"info.png"];
	[infoPage.tabBarItem initWithTitle:@"info" image:[UIImage imageWithContentsOfFile:filePath] tag:0];
	// Create the toolbar and add the view controllers
	UITabBarController *tbarController = [[UITabBarController alloc] init];
	tbarController.viewControllers = controllers;
	tbarController.customizableViewControllers = controllers;
	tbarController.delegate = self;
	[tbarController shouldAutorotateToInterfaceOrientation:YES];
	
	// Configure and show the window
	[window addSubview:tbarController.view];
	[window makeKeyAndVisible];
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //Doesnt really work because views with a tab bar cant be rotated.....
	return (YES);
}

-(void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	[[Beacon shared] endBeacon];
}

-(void)loadView
{
}- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
