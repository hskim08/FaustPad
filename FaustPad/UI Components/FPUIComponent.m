//
//  FPUIComponent.m
//  FaustPad
//
//  Created by Ethan Kim on 10/24/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "FPUIComponent.h"

@implementation FPUIComponent

@synthesize cid;
@synthesize label;
@synthesize varname;

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
//    return [NSString stringWithFormat:@"/%@", [[label lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    return [[label lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
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
