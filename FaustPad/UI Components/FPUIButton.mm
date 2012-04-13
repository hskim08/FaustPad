//
//  FPUIButton.m
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

#import "FPUIButton.h"

#import "mo_net.h"

#import "ServerData.h"

@implementation FPUIButton

@synthesize button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        button.multipleTouchEnabled = YES;
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(handleButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(handleButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
    return self;
}

- (void) setLabel:(NSString *)label
{
    [super setLabel:label];
    
    [button setTitle:label forState:UIControlStateNormal];
}

- (void) handleButtonPressed:(UIButton*)sender
{
    NSLog(@"button %d(%@) pressed", self.cid, [self labelToArg]);

    // send OSC message
    [self sendOscMessageWithValue:1];
}

- (void) handleButtonReleased:(UIButton*)sender
{
    NSLog(@"button %d(%@) released", self.cid, [self labelToArg]);

    // send OSC message
    [self sendOscMessageWithValue:0];
}

@end
