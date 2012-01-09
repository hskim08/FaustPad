//
//  FPUIHSlider.m
//  FaustPad
//
//  Created by Ethan Kim on 10/24/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

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

std::map<std::string, UdpTransmitSocket *> m_cache;
unsigned int m_output_buffer_size = 1024;
- (void) handleValueChanged:(UISlider*)sender
{
    NSLog(@"slider %d(%@) value: %.2f", self.cid, [self labelToArg], sender.value);
    
    char types[3] = {'i', 's', 'f'};
    MoNet::sendMessage( 
                       std::string([[ServerData sharedInstance].serverIp cStringUsingEncoding:NSUTF8StringEncoding]), 
                       SC_PORT_TO, 
                       std::string("/n_set"), 
                       types, 
                       3,
                       [ServerData sharedInstance].nodeId,
                       [[self labelToArg] cStringUsingEncoding:NSUTF8StringEncoding],
                       sender.value
                       );

}


@end
