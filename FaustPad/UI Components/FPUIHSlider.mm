//
//  FPUIHSlider.m
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

#import "FPUIHSlider.h"

#import "mo_net.h"

#import "ServerData.h"

@implementation FPUIHSlider

@synthesize slider;
@synthesize sliderLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-25)];
        sliderLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        sliderLabel.textColor = [UIColor lightGrayColor];
        sliderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:sliderLabel];
        
        slider = [[UISlider alloc] initWithFrame:CGRectMake(0, frame.size.height-25, frame.size.width, 25)];
        [slider addTarget:self action:@selector(handleValueChanged:) forControlEvents:UIControlEventValueChanged];
        slider.multipleTouchEnabled = YES;
        slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:slider];
    }
    return self;
}

- (void) setLabel:(NSString *)label
{
    [super setLabel:label];
    
    sliderLabel.text = label;
}

- (void) setMin:(double)minv max:(double)maxv
{
    slider.minimumValue = minv;
    slider.maximumValue = maxv;
}

//std::map<std::string, UdpTransmitSocket *> m_cache;
//unsigned int m_output_buffer_size = 1024;

- (void) handleValueChanged:(UISlider*)sender
{
    NSLog(@"slider %d(%@) value: %.2f", self.cid, [self labelToArg], sender.value);

    // send OSC message
    [self sendOscMessageWithValue:sender.value];
}


@end
