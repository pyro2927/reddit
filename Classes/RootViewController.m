//
//  RootViewController.m
//  
//
//  Created by Joseph Pintozzi on 10/27/08.
//  Copyright MySelf! 2008. All rights reserved.
//
//	Shit that is commented out doesn't work

#import "RootViewController.h"
#import "WebViewController.h"
#import "StoryViewController.h"
#import "TextViewController.h"
#import "Alert.h"
#import "redditAppDelegate.h"


//Coding for WebController
@interface WebController : UIViewController 
{ 
	UIWebView *webView; 
} 
@property (nonatomic, retain)	UIWebView *webView;
@end

@implementation WebController
@synthesize webView; 
- (id)initWithFile: filename 
{ 
	// Read in the HTML source 
	NSString *fileText = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:NULL]; 
	// Initialize the Web view 
	webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]; 
	// Load it with the HTML source 
	[webView loadHTMLString:fileText baseURL:@"html"]; 
	// Allow direct user interaction 
	[webView setScalesPageToFit:YES]; 
	return self; 	
} 
- (void)loadView 
{ 
	self.view = webView; 
	[webView release]; 
}
-(void) dealloc 
{ 
	[webView release]; 
	[super dealloc]; 
} 
@end
//End WebController Code

//HUD View
@interface UIProgressHUD : NSObject
- (void) show: (BOOL) yesOrNo;
- (UIProgressHUD *) initWithWindow: (UIView *) window;
@end
//End HUD View

//RootViewController
@implementation RootViewController
@synthesize navigationController;
@synthesize reddit;
@synthesize path;
@synthesize plistPath;
WebViewController *wvController;
NSURLRequest *request;
id HUD;

//setup this freakin controller
- (id)init
{
	
	path = @"http://www.reddit.com/.rss";
	
	self = [super init];
	if (self)
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"reddit", @"");
	}
	return self;
}

//Push the WebViewController
- (IBAction)pushWebViewMethod:(id)sender{
	NSLog(@"trying to push WebView");
	WebViewController *wvController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
	[[self navigationController] pushViewController:wvController animated:YES];
	
}
-(NSString *)getPath{
	return path;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//Set up number of cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stories count];
}

//Set up cels
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog([NSString stringWithFormat:@"Setting up cell %d:",[indexPath row]]);
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	cell.accessoryType= UITableViewCellAccessoryNone;
	// Set up the cell
	if([indexPath row]==[stories count])
	{
		cell.text = @"Load more...";
		cell.textColor=[UIColor blueColor];
		cell.accessoryType= UITableViewCellAccessoryNone;
	}
	else
	{
		int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
		cell.text = [[stories objectAtIndex: storyIndex] objectForKey: @"title"]; 
		cell.textColor=[UIColor blackColor];
		cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
		cell.font = [UIFont systemFontOfSize:14];
	}
	return cell;
}

//Chevron pressed
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{ 
	[tableView cellForRowAtIndexPath:indexPath].textColor=[UIColor grayColor];
	NSString *storyUser;
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	NSString *storyTitle=[[stories objectAtIndex: storyIndex] objectForKey: @"title"];
	NSLog(@"title %@",storyTitle);
	NSString *commentLink = [[stories objectAtIndex: storyIndex] objectForKey: @"link"];
	// clean up the link - get rid of spaces, returns, and tabs...
	commentLink = [commentLink stringByReplacingOccurrencesOfString:@" " withString:@""];
	commentLink = [commentLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	commentLink = [commentLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
	
	//load actual story link
	NSString *storyLink = [[stories objectAtIndex: storyIndex] objectForKey: @"summary"];
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@"<a href=\"/r/" withString:@"<a href=\"http://reddit.com/r/"];
	NSLog(@"attemping to pull storyLink");
	NSRange startRange=[storyLink rangeOfString:@"<br/> <a href=\""];
	NSRange endRange=[storyLink rangeOfString:@"\">[link]"];
	int startPoint=startRange.length+startRange.location;
	int endPoint=endRange.location;
	NSRange searchRange;
	searchRange.location=startPoint;
	searchRange.length=endPoint-startPoint;
	storyLink=[storyLink substringWithRange:searchRange];
	
	//load comments
	comments = [[stories objectAtIndex: storyIndex] objectForKey: @"summary"];
	comments = [comments stringByReplacingOccurrencesOfString:@"[link]" withString:@""];
	NSLog(@"attemping to pull comment # %@",comments);
	startRange=[comments rangeOfString:@"["];
	endRange=[comments rangeOfString:@"]"];
	startPoint=startRange.length+startRange.location;
	endPoint=endRange.location;
	searchRange;
	searchRange.location=startPoint;
	searchRange.length=endPoint-startPoint;
	comments=[comments substringWithRange:searchRange];
	
	//Load username
	NSString *sum = [[stories objectAtIndex: storyIndex] objectForKey: @"summary"];
	NSLog(@"attemping to modify summary and pull username%@", sum);
	startRange=[sum rangeOfString:@"submitted by <a href=\"http://www.reddit.com/user/"];
	endRange=[sum rangeOfString:@"</a> to <a href=\""];
	startPoint=startRange.length+startRange.location;
	endPoint=endRange.location;
	searchRange.location=startPoint;
	searchRange.length=endPoint-startPoint;
	storyUser=[sum substringWithRange:searchRange];
	NSLog(@"User: %@",storyUser);
	storyUser = [storyUser substringToIndex:storyUser.length/2-1];
	
	//**New way to load view
	StoryViewController *storyViewController = [[StoryViewController alloc] init];
	[storyViewController changeTitle:storyTitle];
	
	//propagate changes over
	storyViewController.storyLink=storyLink;
	storyViewController.commentLink=commentLink;
	storyViewController.user=storyUser;
	storyViewController.commentString=comments;
	NSLog(@"attempting to load StoryView");
	[[self navigationController] pushViewController:storyViewController animated:YES];
	
	/**Load comment page
	NSLog(@"trying to push WebView");
	WebViewController *wvController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
	[[self navigationController] pushViewController:wvController animated:YES];
	//Load the proper comments
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	[wvController setTitle:[[stories objectAtIndex: storyIndex] objectForKey: @"title"]];
	NSString *storyLink = [[stories objectAtIndex: storyIndex] objectForKey: @"link"];
	// clean up the link - get rid of spaces, returns, and tabs...
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@" " withString:@""];
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
	NSURL *url = [NSURL URLWithString:storyLink];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSLog(@"Loading comment page: %@",storyLink);
	[wvController loadPage:request];
	 **/
}

//select story
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView cellForRowAtIndexPath:indexPath].textColor=[UIColor grayColor];
	wvController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
	//Load the proper story
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	NSString *storyLink = [[stories objectAtIndex: storyIndex] objectForKey: @"summary"];
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@"<a href=\"/r/" withString:@"<a href=\"http://reddit.com/r/"];
	[wvController setTitle:[[stories objectAtIndex: storyIndex] objectForKey: @"title"]];
	NSLog(@"attemping to modify storyLink");
	NSRange startRange=[storyLink rangeOfString:@"<br/> <a href=\""];
	NSRange endRange=[storyLink rangeOfString:@"\">[link]"];
	int startPoint=startRange.length+startRange.location;
	int endPoint=endRange.location;
	NSRange searchRange;
	searchRange.location=startPoint;
	searchRange.length=endPoint-startPoint;
	storyLink=[storyLink substringWithRange:searchRange];
	searchRange.location = 0;
	searchRange.length = 22;
	NSString *domain=[storyLink substringWithRange:searchRange];
	NSLog(@"Domain is:%@",domain);
	if([domain isEqual:@"http://www.youtube.com"]||[domain isEqual:@"http://au.youtube.com/"])
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
-(IBAction)refresh{
	//Create seperate pool
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	plistPath = [documentsDirectory stringByAppendingPathComponent:@"path.plist"];
	NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	path=[settingsDict objectForKey:@"path"];
	self.title=[settingsDict objectForKey:@"title"];
	//Load Stories
	stories = NULL;
	NSLog(@"Current Path: %@",path);
	[self parseXMLFileAtURL:path];
	cellSize = CGSizeMake([newsTable bounds].size.width, 60);
	//turn off indicator
	[self stop];
		//release seperate pool
	[pool release];
}
-(IBAction)showHelp{
	TextViewController *textViewController = [[TextViewController alloc] init];
	[[self navigationController] pushViewController:textViewController animated:YES];
}
//Loads stories!
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	//Load stories
	if ([stories count] == 0) {
		//turn on indicator
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		//start seperate thread for stories
		[NSThread detachNewThreadSelector:@selector(refresh) toTarget:self withObject:NULL];
	}
}


//****Method that parses the XML RSS feed!!****
- (void)parseXMLFileAtURL:(NSString *)URL {
	stories = [[NSMutableArray alloc] init];
	
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:URL];
	
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[rssParser setDelegate:self];
	
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];
	
	[rssParser parse];
}
//****More XML parsing!!!!****
- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");
}
//Parser error
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
		currentUser = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		// save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:currentLink forKey:@"link"];
		[item setObject:currentSummary forKey:@"summary"];
		[item setObject:currentDate forKey:@"date"];
		[item setObject:currentUser	forKey:@"user"];
		
		[stories addObject:[item copy]];
		
		//NSLog(@"adding story: %@", currentSummary);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"link"]) {
		[currentLink appendString:string];
	} else if ([currentElement isEqualToString:@"description"]) {
		[currentSummary appendString:string];
	} else if ([currentElement isEqualToString:@"pubDate"]) {
		[currentDate appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	[activityIndicator stopAnimating];
	[activityIndicator removeFromSuperview];
	
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	[newsTable reloadData];
}
-(void)loadView
{
	[super loadView];
	self.view.autoresizesSubviews = YES; 
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.navigationItem.leftBarButtonItem.width=20.0f;
	// create and configure the table view
	newsTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];	
	newsTable.delegate = self;
	newsTable.dataSource = self;
	newsTable.autoresizesSubviews = YES;
	[self configureAccelerometer];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"subredditChanged" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:@"doneRefreshing" object:nil];
	self.view = newsTable;
}
//Turn off activity indicator
-(void)stop{
	NSLog(@"Stoping activity indicator");
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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

#define kAccelerometerFrequency        50 //Hz
-(void)configureAccelerometer
{
	
    UIAccelerometer*  theAccelerometer = [UIAccelerometer sharedAccelerometer];
	
    theAccelerometer.updateInterval = 1 / kAccelerometerFrequency;
	
	
	
    theAccelerometer.delegate = self;
	
    // Delegate events begin immediately.
	
}
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
	if (fabsf(acceleration.x) > 1.5 || fabsf(acceleration.y) > 1.5 || fabsf(acceleration.z) > 1.5) 
	{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		NSLog(@"Phone was shook");
	}
	
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
	[super dealloc];
}
@end