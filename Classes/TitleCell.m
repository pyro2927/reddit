//
//  TitleCell.m
//  reddit
//
//  Created by Joseph Pintozzi on 11/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TitleCell.h"
#import "Constants.h"

#define kInsertValue	8.0

@implementation TitleCell
NSString *kTitleCell_ID = @"title";
@synthesize titleLabel;

- (id)initWithFrame:(CGRect)aRect reuseIdentifier:(NSString *)identifier
{
	if (self = [super initWithFrame:aRect reuseIdentifier:identifier])
	{
		// turn off selection use
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		titleLabel = [[UILabel alloc] initWithFrame:aRect];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.opaque = NO;
		titleLabel.textAlignment = UITextAlignmentLeft;
		titleLabel.textColor = [UIColor blackColor];
		titleLabel.highlightedTextColor = [UIColor blackColor];
		titleLabel.font = [UIFont systemFontOfSize:14];
		titleLabel.numberOfLines=10;
		[titleLabel sizeToFit];
		[self.contentView addSubview:titleLabel];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect contentRect = [self.contentView bounds];
	
	// inset the text view within the cell
	if (contentRect.size.width > (kInsertValue*2))	// but not if the width is too small
	{
		titleLabel.frame  = CGRectMake(contentRect.origin.x + kInsertValue,
									  contentRect.origin.y + kInsertValue,
									  contentRect.size.width - (kInsertValue*2),
									  contentRect.size.height - (kInsertValue*2));
	}
}

- (void)dealloc
{
	[titleLabel release];
	
    [super dealloc];
}

@end
