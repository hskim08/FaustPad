//
//  ServerData.h
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

#import <Foundation/Foundation.h>

#define IP_MTU_SIZE 1536

#define SC_PORT_TO 57110
#define SC_PORT_FROM 57120

@interface ServerData : NSObject

@property (nonatomic, strong) NSString* serverIp;
@property (nonatomic) NSUInteger inPort;
@property (nonatomic) NSUInteger outPort;

@property (nonatomic) NSUInteger nodeAssign;

+ (ServerData *)sharedInstance;

- (void)saveData;
- (void)loadData;

- (NSUInteger) getNewNodeId;

@end
