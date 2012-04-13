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
        
        serverIp = @"192.168.176.112";

        inPort = SC_PORT_FROM;
        outPort = SC_PORT_TO;
        
        nodeAssign = 999;
    }
    return  self;
}

- (void)saveData
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.serverIp forKey:@"IP"];
    [defaults setInteger:self.inPort forKey:@"inPort"];
    [defaults setInteger:self.outPort forKey:@"outPort"];
    [defaults synchronize];
}

- (void)loadData
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    self.serverIp = [defaults objectForKey:@"IP"];
    self.inPort = [defaults integerForKey:@"inPort"];
    self.outPort = [defaults integerForKey:@"outPort"];
}

- (NSUInteger) getNewNodeId
{
    nodeAssign++;
    return nodeAssign;
}

@end
