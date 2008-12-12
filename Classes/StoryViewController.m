//
//  StoryViewController.m
//  redditPro
//
//  Created by Joseph Pintozzi on 11/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "StoryViewController.h"
#import "Constants.h"
#import "SourceCell.h"
#import "TitleCell.h"
#import "WebViewController.h"
#import "CellTextView.h"


@implementation StoryViewController
@synthesize user;
@synthesize commentLink;
@synthesize storyLink;
@synthesize commentString;
@synthesize myTableView;
NSURL *hyperlink;

- (id)init
{
	self.title=@"Overview";
	hyperlink=nil;
	self.user=@"";
	// this title will appear in the navigation bar
	return self;
}
-(void)viewWillAppear:(BOOL)animated{
	
}
- (void)loadView
{
	// create and configure the table view
	myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.scrollEnabled = YES; // no scrolling in this case, we don't want to interfere with text view scrolling
	myTableView.autoresizesSubviews = YES;
	self.view = myTableView;
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.navigationItem.leftBarButtonItem.width=20.0f;
}

- (UITextView *)create_UITextView
{
	NSLog(@"Creating CGRect");
	CGRect frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
	NSLog(@"Creating UITextView");
	UITextView *textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont fontWithName:@"Arial" size:18];
	NSLog(@"Setting delegate");
    textView.delegate = self;
    textView.backgroundColor = [UIColor whiteColor];
	textView.editable=NO;
	textView.text = @"Story";
	[textView sizeToFit];
	return textView;
}


#pragma mark - Change Features
-(void)changeTitle:(NSString *)t
{
	title=t;
}
-(void)changeLink:(NSURL *)l
{
	hyperlink=l;
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
#pragma mark - UITableView delegates
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{
	switch ([indexPath section])
	{
			//if in section 0
		case 0:
			{
				switch ([indexPath row])
				{
					case 0:
					{
						NSLog(@"Webview story");
						WebViewController *wvController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
						NSRange searchRange;
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
							[self setTitle:@"OverView"];
							NSLog(@"Attempting to load the story");
							//Load the proper story
							[wvController setTitle:title];
							hyperlink = [NSURL URLWithString:storyLink];
							NSURLRequest *request = [NSURLRequest requestWithURL:hyperlink];
							[[self navigationController] pushViewController:wvController animated:YES];
							NSLog(@"Loading web story page");			
							[wvController loadPage:request];
							
						}
						break;
					}
					case 1:
					{
						NSLog(@"Webview comments");
						WebViewController *wvController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
						[self setTitle:@"OverView"];
						[[self navigationController] pushViewController:wvController animated:YES];
						NSLog(@"Attempting to load the comments");
						//Load the proper comments
						[wvController setTitle:@"Comments"];
						hyperlink = [NSURL URLWithString:commentLink];
						NSURLRequest *request = [NSURLRequest requestWithURL:hyperlink];
						NSLog(@"Loading web comment page");			
						[wvController loadPage:request];
						break;
					}
					break;
				}
				break;
				//end section 0
			}
		case 1:
		{
			NSLog(@"Webview userpage");
			WebViewController *wvController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
			[self setTitle:@"OverView"];
			[[self navigationController] pushViewController:wvController animated:YES];
			NSLog(@"Attempting to load the users page");
			//Load the proper comments
			[wvController setTitle:user];
			NSString *userString=@"http://www.reddit.com/user/";
			userString=[userString stringByAppendingString:user];
			hyperlink = [NSURL URLWithString:userString];
			NSURLRequest *request = [NSURLRequest requestWithURL:hyperlink];
			NSLog(@"Loading user page");			
			[wvController loadPage:request];
			break;
		}
	}
	//end all switches
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Cell pressed");
}
// if you want the entire table to just be re-orderable then just return UITableViewCellEditingStyleNone

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
		{
			return @"Story";
			break;
		}
		case 1:
		{
			return @"User";
			break;
		}
		default:
		{
			return @"";
			break;
		}
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
		{
			return 2;
			break;
		}
		case 1:
		{
			return 1;
			break;
		}
		default:
		{
			return 2;
			break;
		}
	}
}

// to determine specific row height for each cell, override this.  In this example, each row is determined
// buy the its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat result;
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	switch (row)
	{
		case 0:
		{
			if(section==1)
				result=50;
			else
			{
				result = 75;
			}
			break;
		}
		case 1:
		{
			result = 30;
			break;
		}
		default:
		{
			result=50;
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
		cell = [myTableView dequeueReusableCellWithIdentifier:@"storyCell"];
	else if (row == 1)
		cell = [myTableView dequeueReusableCellWithIdentifier:@"submittor"];
	
	if (cell == nil)
	{
		if (row == 0)
		{
			cell = [[[TitleCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"storyCell"] autorelease];
		}
		else if (row == 1)
			cell = [[[SourceCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"submittor"] autorelease];
	}
	cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
	[cell sizeToFit];
	return cell;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	UITableViewCell *sourceCell = [self obtainTableCellForRow:row];
	NSInteger section = [indexPath section];
	
	// we are creating a new cell, setup its attributes
	if(section==1)
	{
		((TitleCell *)sourceCell).titleLabel.text = self.user;
	}
	else if (row == 0)
	{
		// this cell hosts the UISwitch control
		((TitleCell *)sourceCell).titleLabel.text = title;
	}
	else
	{
		// this cell hosts the info on where to find the code
		((SourceCell *)sourceCell).sourceLabel.text = self.commentString;
	}
	
	return sourceCell;
}

@end
