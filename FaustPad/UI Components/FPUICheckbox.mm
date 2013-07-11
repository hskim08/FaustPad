//
//  FPUICheckbox.m
//  FaustPad
//
//  Created by Hyung-Suk Kim on 10/24/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//
/*-----------------------------------------------------------------------------
 Permission is hereby granted, free of charge, to any person obtaining a 
 copy of this software and associated documentation files (the "Software"), 
 to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The authors encourage users of FaustPad to include this copyright notice,
 and to let us know that you are using FaustPad. Any person wishing to 
 distribute modifications to the Software is encouraged to send the 
 modifications to the original authors so that they can be incorporated 
 into the canonical version.
 
 The Software is provided "as is", WITHOUT ANY WARRANTY, express or implied,
 including but not limited to the warranties of MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE and NONINFRINGEMENT.  In no event shall the authors
 or copyright holders by liable for any claim, damages, or other liability,
 whether in an actino of a contract, tort or otherwise, arising from, out of
 or in connection with the Software or the use or other dealings in the 
 software.
 -----------------------------------------------------------------------------*/

#import "FPUICheckbox.h"

#import "mo_net.h"

#import "ServerData.h"

@implementation FPUICheckbox

@synthesize checkbox;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        checkbox = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        checkbox.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        checkbox.multipleTouchEnabled = YES;
        
        [checkbox setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [checkbox addTarget:self action:@selector(handleCheckboxPressed:) forControlEvents:UIControlEventTouchDown];
        

	// From http://stackoverflow.com/questions/5368196/how-create-simple-checkbox
	// NEED CHECKBOX IMAGES
	// checkbox = [[UIButton alloc] initWithFrame:CGRectMake(x,y,20,20)
	// // 20x20 is the size of the checckbox that you want
	// // create 2 images sizes 20x20 , one empty square and
	// // another of the same square with the checkmark in it
	// // Create 2 UIImages with these new images, then:
	// [checkbox setBackgroundImage:[UIImage imageNamed:@"notselectedcheckbox.png"]
	//                     forState:UIControlStateNormal];
	// [checkbox setBackgroundImage:[UIImage imageNamed:@"selectedcheckbox.png"]
	//                     forState:UIControlStateSelected];
	// [checkbox setBackgroundImage:[UIImage imageNamed:@"selectedcheckbox.png"]
	//                     forState:UIControlStateHighlighted];
	// checkbox.adjustsImageWhenHighlighted=YES;

        [self addSubview:checkbox];
    }
    return self;
}

- (void) setLabel:(NSString *)label
{
    [super setLabel:label];
    
    [checkbox setTitle:label forState:UIControlStateNormal];
}

- (void) handleCheckboxPressed:(UIButton*)sender
{
    NSLog(@"checkbox %d(%@) pressed", self.cid, [self labelToArg]);

    // toggle state
    _checked = ! _checked;

    // send OSC message
    [self sendOscMessageWithValue:(_checked ? 1 : 0)];
}

@end
