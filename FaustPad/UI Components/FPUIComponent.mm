//
//  FPUIComponent.m
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

#import "FPUIComponent.h"

#import "ServerData.h"
#import "mo_net.h"

@implementation FPUIComponent

@synthesize cid;
@synthesize label;
@synthesize varname;
@synthesize nodeId;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// changes the label to the supercollider property argument
-(NSString*) labelToArg
{
    return [[label lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
}

- (void) sendOscMessageWithValue:(float)value
{
    ServerData* server = [ServerData sharedInstance];
    
    char types[3] = {'i', 's', 'f'};
    MoNet::sendMessage( 
                       std::string([server.serverIp cStringUsingEncoding:NSUTF8StringEncoding]), 
                       server.outPort, 
                       std::string("/n_set"), 
                       types,
                       3,
                       self.nodeId,
                       [[self labelToArg] cStringUsingEncoding:NSUTF8StringEncoding],
                       value
                       );

}

- (void) setMin:(double)minv max:(double)maxv
{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
