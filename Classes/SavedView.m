//
//  RootViewController.m
//  
//
//  Created by Joseph Pintozzi on 10/27/08.
//  Copyright MySelf! 2008. All rights reserved.
//
//	Shit that is commented out doesn't work

#import "SavedView.h"
#import "WebViewController.h"
#import "StoryViewController.h"
#import "TextViewController.h"
#import "Alert.h"
#import "redditAppDelegate.h"


//RootViewController
@implementation SavedView
@synthesize navigationController;
@synthesize reddit;
@synthesize path;
@synthesize plistPath;
@synthesize savedStories;
@synthesize selection;
WebViewController *wvController;
NSURLRequest *request;

//setup this freakin controller
- (id)init
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"saved.plist"];
	self.savedStories = [NSArray arrayWithContentsOfFile:finalPath];
	NSLog(@"Number of saved stories inside SavedView: %d", [savedStories count]);
	self = [super init];
	if (self)
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"Saved", @"");
	}
	NSLog(@"Initialize fine");
	return self;
}

//Push the WebViewController
- (IBAction)pushWebViewMethod:(id)sender{
	NSLog(@"trying to push WebView");
	WebViewController *wvController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
	[[self navigationController] pushViewController:wvController animated:YES];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//Set up number of cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//NSLog(@"Number of rows: %d",[savedStories count]);
    return 1;
}

//Set up cels
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"Attempting to create cell");
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	// Set up the cell
	NSLog(@"Pulling selection");
	self.selection = [self.savedStories objectAtIndex:0];
	NSLog(@"Selection pulled");
	NSLog(@"Number of items in selection: %d",[selection count]);
	cell.text = [[self.savedStories objectAtIndex:[indexPath row]] objectForKey:@"title"];
	//cell.text=@"test";
	cell.textColor=[UIColor blackColor];
	cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
	return cell;
}

//Chevron pressed
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{ 
	//**New way to load view
	StoryViewController *storyViewController = [[StoryViewController alloc] init];
	[storyViewController changeTitle:[[self.savedStories objectAtIndex:[indexPath row]] objectForKey:@"title"]];
	
	//propagate changes over
	storyViewController.storyLink=[[self.savedStories objectAtIndex:[indexPath row]] objectForKey:@"url"];;
	storyViewController.commentLink=[[self.savedStories objectAtIndex:[indexPath row]] objectForKey:@"commenturl"];;
	storyViewController.user=[[self.savedStories objectAtIndex:[indexPath row]] objectForKey:@"submittor"];;
	storyViewController.commentString=[[self.savedStories objectAtIndex:[indexPath row]] objectForKey:@"comments"];;
	NSLog(@"attempting to load StoryView");
	[[self navigationController] pushViewController:storyViewController animated:YES];
	self.title=@"Saved";
}

//select story
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	wvController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
	[wvController setTitle:[self.selection objectForKey: @"title"]];
	NSString *storyLink=[self.selection objectForKey:@"url"];
	NSRange searchRange;
	searchRange.location=0;
	searchRange.length=22;
	NSString *domain=[storyLink substringWithRange:searchRange];
	NSLog(@"Domain is:%@",domain);
	if([domain isEqual:@"http://www.youtube.com"])
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: storyLink]];
	}
	else
	{
		[[self navigationController] pushViewController:wvController animated:YES];
		request = [NSURLRequest requestWithURL:[NSURL URLWithString: storyLink]];
		NSLog(@"Loading story page:%@",storyLink);
		//Comment out for now to try threading
		[wvController loadPage:request];
		//[NSThread detachNewThreadSelector:@selector(loadPage) toTarget:self withObject:NULL];
	}
}
//seperate method to allow threading of loadpage
-(void)loadPage{
	[wvController loadPage:request];
}

//Loads stories!
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:YES];
	//NSLog(@"View did appear fine");
	/*
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"saved.plist"];
	savedStories = [NSArray arrayWithContentsOfFile:finalPath];
	 */
}


-(void)loadView
{
	[super loadView];
	self.view.autoresizesSubviews = YES; 
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	// create and configure the table view
	//newsTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];	
	newsTable.delegate = self;
	newsTable.dataSource = self;
	newsTable.autoresizesSubviews = YES;
	//[self.view addSubview:newsTable];
	NSLog(@"loadview for saved view fine");
}

/*
 - (void)viewWillDisappear:(BOOL)animated {
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 }
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (YES);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[currentElement release];
	[rssParser release];
	[stories release];
	[item release];
	[currentTitle release];
	[currentDate release];
	[currentSummary release];
	[currentLink release];
	[currentUser release];
	[savedStories release];
	[super dealloc];
}
@end