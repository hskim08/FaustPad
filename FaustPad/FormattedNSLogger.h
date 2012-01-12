//
//  FormattedNSLogger.h
//  FaustPad
//
//  Created by Ethan on 1/11/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormattedNSLogger : NSObject

+(void) printFrame:(CGRect)frame withName:(NSString*)name;

@end
