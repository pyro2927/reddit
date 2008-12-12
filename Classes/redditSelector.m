//
//  redditSelector.m
//  reddit
//
//  Created by Joseph Pintozzi on 11/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "redditSelector.h"
#import "Constants.h"
#import "SourceCell.h"
#import "TitleCell.h"
#import "CellTextView.h"

@implementation redditSelector
@synthesize myPickerView;
@synthesize myTableView;
@synthesize subredditText;
@synthesize parent;

- (id)init
{
	self = [super init];
	if (self)
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"PickerTitle", @"");
	}
	
	return self;
}

// return the picker frame based on its size, positioned at the bottom of the page
- (CGRect)pickerFrameWithSize:(CGSize)size
{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(	0.0,
								   screenRect.size.height - kToolbarHeight - 4.0 - size.height,
								   size.width,
								   size.height);
	return pickerRect;
}

#pragma mark 
#pragma mark UIPickerView
#pragma mark
- (void)createPicker
{
	pickerViewArray = [[NSArray arrayWithObjects:
						@"reddit.com", @"bacon", @"politics", @"pics",
						@"WTF", @"funny", @"technology", @"programming",
						nil] retain];
	// note we are using CGRectZero for the dimensions of our picker view,
	// this is because picker views have a built in optimum size,
	// you just need to set the correct origin in your view.
	//
	// position the picker at the bottom
	myPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
	CGSize pickerSize = [myPickerView sizeThatFits:CGSizeZero];
	myPickerView.frame = [self pickerFrameWithSize:pickerSize];
	
	myPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	myPickerView.delegate = self;
	myPickerView.showsSelectionIndicator = YES;	// note this is default to NO
	
	// add this picker to our view controller, initially hidden
	myPickerView.hidden = YES;
	[self.view addSubview:myPickerView];
}

- (void)showPicker:(UIView *)picker
{
	// hide the current picker and show the new one
	if (currentPicker)
	{
		currentPicker.hidden = YES;
		label.text = @"";
	}
	picker.hidden = NO;
	
	currentPicker = picker;	// remember the current picker so we can remove it later when another one is chosen
}

- (void)loadView
{		
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	
	// setup our parent content view and embed it to your view controller
	UIView *contentView = [[UIView alloc] initWithFrame:screenRect];
	contentView.backgroundColor = [UIColor blackColor];
	contentView.autoresizesSubviews = YES;
	contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	self.view = contentView;
	[contentView release];
	
	[self createPicker];
	CGRect tableFrame = CGRectMake(0.0,0.0,320.0,200);
	// create and configure the table view
	myTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.scrollEnabled = NO; // no scrolling in this case, we don't want to interfere with text view scrolling
	myTableView.autoresizesSubviews = YES;
	
	[self.view addSubview:myTableView];
	
	// label for picker selection output, place it right above the picker
	CGRect labelFrame = CGRectMake(	kRightMargin, 140.0,
								   self.view.bounds.size.width - (kRightMargin * 2.0),
								   40);
	label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont systemFontOfSize: 14];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor clearColor];
	[self.view addSubview:label];
	

	// start by showing the normal picker
	buttonBarSegmentedControl.selectedSegmentIndex = 0.0;
}

- (void)dealloc
{
	[myTableView release];
	[pickerViewArray release];
	[myPickerView release];
	[datePickerView release];
	[label release];
	[customPickerView release];
	
	[pickerStyleSegmentedControl release];
	[segmentLabel release];
	
	[buttonBarSegmentedControl release];
	[buttonBar release];
	
	[super dealloc];
}

- (void)pickerAction:(id)sender
{
	if (myPickerView != currentPicker)
		[self showPicker:myPickerView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// if you want to only support portrait mode, do this
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	
	return NO;
}


#pragma mark -
#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSString *subreddit=[pickerViewArray objectAtIndex:[pickerView selectedRowInComponent:0]];
	// report the selection to the UI label
	if([subreddit isEqual:@"reddit.com"])
	{
		label.text = [NSString stringWithFormat:@"Default reddit selected!"];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"path.plist"];	
		NSDictionary *settingsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:	@"http://www.reddit.com/.rss",@"reddit",nil] forKeys:[NSArray arrayWithObjects:	@"path",@"title",nil]];
		[settingsDict writeToFile:finalPath atomically:YES];
		
	}
	else
	{
		label.text = [NSString stringWithFormat:@"%@ subreddit selected!", subreddit];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"path.plist"];
		NSDictionary *settingsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:	[NSString stringWithFormat:@"http://www.reddit.com/r/%@/.rss", subreddit],subreddit,nil] forKeys:[NSArray arrayWithObjects:	@"path",@"title",nil]];
		[settingsDict writeToFile:finalPath atomically:YES];
		NSLog([NSString stringWithFormat:@"http://www.reddit.com/r/%@/.rss", subreddit]);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSLog(@"Stating that the subreddit has been changed");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"subredditChanged" object:self];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *returnStr;
	if (component == 0)
	{
		returnStr = [pickerViewArray objectAtIndex:row];
	}
	else
	{
		returnStr = [[NSNumber numberWithInt:row] stringValue];
	}
	return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 280.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerViewArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}


#pragma mark UIViewController delegate methods

// called after this controller's view was dismissed, covered or otherwise hidden
- (void)viewWillDisappear:(BOOL)animated
{
	currentPicker.hidden = YES;
}

// called after this controller's view will appear
- (void)viewWillAppear:(BOOL)animated
{
	subredditText=@"";
	pickerStyleSegmentedControl.hidden = YES;
	segmentLabel.hidden = YES;
	[self showPicker:myPickerView];
}

#pragma mark UITableViewController delegate methods
// if you want the entire table to just be re-orderable then just return UITableViewCellEditingStyleNone
//
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Subreddits:";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

// to determine specific row height for each cell, override this.  In this example, each row is determined
// buy the its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat result;
	
	switch ([indexPath row])
	{
		case 0:
		{
			result = 140.0;
			break;
		}
		case 1:
		{
			result = kUIRowLabelHeight;
			break;
		}
	}
	
	return result;
}

// utility routine leveraged by 'cellForRowAtIndexPath' to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)obtainTableCellForRow:(NSInteger)row
{
	UITableViewCell *cell = nil;
	
	if (row == 0)
		cell = [myTableView dequeueReusableCellWithIdentifier:@"text"];
	else if (row == 1)
		cell = [myTableView dequeueReusableCellWithIdentifier:@"shouldntBeUsed"];
	
	if (cell == nil)
	{
		if (row == 0)
			cell = [[[CellTextView alloc] initWithFrame:CGRectZero reuseIdentifier:@"text"] autorelease];
		else if (row == 1)
			cell = [[[SourceCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"shouldntBeUsed"] autorelease];
	}
	
	return cell;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	UITableViewCell *sourceCell = [self obtainTableCellForRow:row];
	
	// we are creating a new cell, setup its attributes
	if (row == 0)
	{
		// this cell hosts the UISwitch control
		((CellTextView *)sourceCell).view = [self create_UITextView];
	}
	else
	{
		// this cell hosts the info on where to find the code
		((SourceCell *)sourceCell).sourceLabel.text = @"TextViewController.m - create_UITextView";
	}
	
	return sourceCell;
}

- (UITextView *)create_UITextView
{
	CGRect frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
	
	UITextView *textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont fontWithName:kFontName size:kTextViewFontSize];
    textView.delegate = self;
    textView.backgroundColor = [UIColor whiteColor];
	textView.editable=NO;
	textView.text = [NSString stringWithFormat:@"Pick a subreddit. You will have to press the 'Refresh' button to load the subreddits links.\n%@",subredditText];
	return textView;
}

@end
