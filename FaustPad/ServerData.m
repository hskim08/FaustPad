//
//  ServerData.m
//  FaustPad
//
//  Created by Ethan Kim on 11/1/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "ServerData.h"

static ServerData *sharedInstance = nil;

@implementation ServerData

@synthesize serverIp, inPort, outPort;
@synthesize nodeAssign;

+ (ServerData *)sharedInstance
{
    if (sharedInstance == nil)
        sharedInstance = [[ServerData alloc] init];
    
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    if ( self ) {
        
        serverIp = @"menlo.stanford.edu";

        inPort = SC_PORT_FROM;
        outPort = SC_PORT_TO;
        
        nodeAssign = 999;
    }
    return  self;
}

- (NSUInteger) getNewNodeId
{
    nodeAssign++;
    return nodeAssign;
}

@end
