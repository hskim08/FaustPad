//
//  FPUIComponent.m
//  FaustPad
//
//  Created by Ethan Kim on 10/24/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

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
