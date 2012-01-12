//
//  FormattedNSLogger.m
//  FaustPad
//
//  Created by Ethan on 1/11/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "FormattedNSLogger.h"

@implementation FormattedNSLogger

+(void) printFrame:(CGRect)frame withName:(NSString*)name
{
    NSLog(@"%@: %.3f/%.3f/%.3f/%.3f", 
          name, 
          frame.origin.x, 
          frame.origin.y, 
          frame.size.width,
          frame.size.height);
}

@end
