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

@synthesize serverIp;
@synthesize nodeId;

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
        
        serverIp = @"128.12.142.63";
        nodeId = 1000;
    }
    return  self;
}

@end
