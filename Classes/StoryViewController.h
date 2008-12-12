//
//  StoryViewController.h
//  redditPro
//
//  Created by Joseph Pintozzi on 11/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StoryViewController : UIViewController <UIScrollViewDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
	UITableView	*myTableView;
	NSString *title, *commentLink, *storyLink;
	NSString *user, *commentString;
}

@property (nonatomic, retain) UITableView *myTableView;
@property (copy) NSString *commentLink, *storyLink;
@property (copy) NSString *user, *commentString;
-(void)changeTitle:(NSString *)t;
-(void)changeLink:(NSURL *)l;
-(void)changeUser:(NSString *)u;

@end