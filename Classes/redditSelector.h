//
//  redditSelector.h
//  reddit
//
//  Created by Joseph Pintozzi on 11/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class	CustomPicker;

@interface redditSelector : UIViewController <UIPickerViewDelegate>{
	UIPickerView		*myPickerView;
	UIDatePicker		*datePickerView;
	NSArray				*pickerViewArray;
	UILabel				*label;
	CustomPicker		*customPickerView;
	
	UIView				*currentPicker;
	
	UIToolbar			*buttonBar;
	UISegmentedControl	*buttonBarSegmentedControl;
	
	UISegmentedControl	*pickerStyleSegmentedControl;
	UILabel				*segmentLabel;
	UITableView			*myTableView;
	NSMutableString		*subredditText;
	NSObject			*parent;
}
@property (nonatomic, retain) UIPickerView *myPickerView;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableString *subredditText;
@property (nonatomic, retain) NSObject *parent;

@end
