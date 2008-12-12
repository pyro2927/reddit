//
//  Alert.h
//  reddit
//
//  Created by Joseph Pintozzi on 11/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#define	TITLE_TAG	999
#define	MESSAGE_TAG	998

@interface TopAlert : UIView
- (void) setTitle: (NSString *)titleText;
- (void) setMessage: (NSString *)messageText;
@end


