//
//  redditAppDelegate.h
//  reddit
//
//  Created by Joseph Pintozzi on 10/27/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//
/*
 So because I'm being pushed to make this open source, I'm going to try to just throw a shit ton of comments in right here for now
 and work out the details later.  The main reddit view is created from class RootViewController, WebViewController is what is pushed when
 a cell is clicked.  Pushing on the blue arrow (chevron) insteaqd launches StoryViewController.  CellTextView is a subview of the UITableCells
 in both TextViewController and StoryViewController.  Same goes for TitleCell.  RedditSelector is the spinny wheel that allows you to
 select different subreddits.  SavedView was never fully implemented, but its mean to pull saved sites and load them into a view.
 My two ideas for doing this were either full them from http://reddit.com/*user/saved blah blah, or create a local plist (or database)
 and have the stories load locally from there.  This option would be faster because it doesnt have to pull data from the web.
 That's mostly it for now. I know, its short its crude, but it works.  I will work more on adding comments after my exams are done this week.
 If you have any specific questions please feel free to email me @ reddit@pintozzi.com  I will answer any questions you have!
 
 Joseph Pintozzi 
 
 */
#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "SavedView.h"
@interface redditAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	UINavigationController *saved;
	RootViewController *reddit;
	NSString *path;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *saved;
@property (nonatomic, retain) IBOutlet RootViewController *reddit;
@property (nonatomic, retain) IBOutlet NSString *path;

@end

