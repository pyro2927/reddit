//
//  Alert.m
//  reddit
//
//  Created by Joseph Pintozzi on 11/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Alert.h"


@implementation TopAlert
- (void) setTitle: (NSString *)titleText
{
	[(UILabel *)[self viewWithTag:TITLE_TAG] setText:titleText];
}

- (void) setMessage: (NSString *)messageText
{
	[(UILabel *)[self viewWithTag:MESSAGE_TAG] setText:messageText];
}

- (TopAlert *) initWithFrame: (CGRect) rect
{
	rect.origin.y = 20.0f - rect.size.height; // Place above status bar
	self = [super initWithFrame:rect];
	
	[self setAlpha:0.9];
	
	// Add button
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(220.0f, 200.0f, 80.0f, 32.0f)];
	[button setBackgroundImage:[UIImage imageNamed:@"whiteButton.png"] forState:UIControlStateNormal];
	[button setTitle:@"Okay" forState: UIControlStateHighlighted];
	[button setTitle:@"Okay" forState: UIControlStateNormal];	
	[button setFont:[UIFont boldSystemFontOfSize:14.0f]];
	[button addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:button];
	
	// Add title
	UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 8.0f, 320.0f, 32.0f)];
	title.text = @"Declaration of Independence";
	title.textAlignment = UITextAlignmentCenter;
	title.textColor = [UIColor whiteColor];
	title.backgroundColor = [UIColor clearColor];
	title.font = [UIFont boldSystemFontOfSize:20.0f];
	[self addSubview:title];
	[title release];
	
	// Add message
	UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 40.0f, 280.0f, 200.0f - 48.0f)];
	message.text = @"When in the Course of human events, it becomes necessary for one people to dissolve the political bands which have connected them with another, and to assume among the powers of the earth, the separate and equal station to which the Laws of Nature and of Nature's God entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation.";
	message.textAlignment = UITextAlignmentCenter;
	message.numberOfLines = 999;
	message.textColor = [UIColor whiteColor];
	message.backgroundColor = [UIColor clearColor];
	message.lineBreakMode = UILineBreakModeWordWrap;
	message.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
	[self addSubview:message];
	[message release];	
	
	return self;
}

- (void) removeView
{
	// Scroll away the overlay
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	
	CGRect rect = [self frame];
	rect.origin.y = -10.0f - rect.size.height;
	[self setFrame:rect];
	
	// Complete the animation
	[UIView commitAnimations];
}

- (void) presentView
{
	// Scroll in the overlay
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	
	CGRect rect = [self frame];
	rect.origin.y = 0.0f;
	[self setFrame:rect];
	
	// Complete the animation
	[UIView commitAnimations];
}
@end
