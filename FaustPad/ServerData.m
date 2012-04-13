//
//  ServerData.m
//  FaustPad
//
//  Created by Hyung-Suk Kim on 11/1/11.
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
