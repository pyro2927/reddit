//
//  TitleCell.h
//  reddit
//
//  Created by Joseph Pintozzi on 11/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *kTitleCell_ID;
@interface TitleCell : UITableViewCell {
	UILabel	*titleLabel;
}

@property (nonatomic, retain) UILabel *titleLabel;

@end
