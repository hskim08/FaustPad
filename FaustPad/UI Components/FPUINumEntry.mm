//
//  FPUINumEntry.m
//  FaustPad
//
//  Created by Ethan Kim on 10/24/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

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
