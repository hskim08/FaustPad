//
//  FPUIButton.m
//  FaustPad
//
//  Created by Ethan Kim on 10/24/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

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
