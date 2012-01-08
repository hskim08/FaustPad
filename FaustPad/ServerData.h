//
//  ServerData.h
//  FaustPad
//
//  Created by Ethan Kim on 11/1/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IP_MTU_SIZE 1536

#define SC_PORT_TO 57110
#define SC_PORT_FROM 57120

@interface ServerData : NSObject

@property (nonatomic, strong) NSString* serverIp;

+ (ServerData *)sharedInstance;

@end
