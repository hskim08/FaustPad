//
//  FPUINumEntry.m
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

#import "FPUINumEntry.h"

#import "mo_net.h"

#import "ServerData.h"

@implementation FPUINumEntry

@synthesize entryLabel;
@synthesize numEntry;
@synthesize minValue, maxValue;
@synthesize value = _value;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        entryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-50, frame.size.width, 25)];
        entryLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        entryLabel.textColor = [UIColor lightGrayColor];
        entryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:entryLabel];
        
        numEntry = [[UITextField alloc] initWithFrame:CGRectMake(0, frame.size.height-25, frame.size.width, 25)];
        numEntry.backgroundColor = [UIColor whiteColor];
        numEntry.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        numEntry.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        numEntry.clearButtonMode = UITextFieldViewModeWhileEditing;
        numEntry.delegate = self;
        [self addSubview:numEntry];
    }
    return self;
}

- (void) setLabel:(NSString *)label
{
    [super setLabel:label];
    
    entryLabel.text = label;
}

- (void) setMin:(double)minv max:(double)maxv
{
    minValue = minv;
    maxValue = maxv;
}

- (void) setValue:(double)v
{
    _value = fmax(self.minValue, fmin(self.maxValue, v));
    numEntry.text = [NSString stringWithFormat:@"%.3f", _value];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textfield %d(%@) text:%@", self.cid, [self labelToArg], numEntry.text);
    
    // parse text to number
    self.value = [textField.text doubleValue];
    
    // send OSC message
    [self sendOscMessageWithValue:self.value];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // hide keyboard
    [textField resignFirstResponder];
    
    return YES;
}

@end
