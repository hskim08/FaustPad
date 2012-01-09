//
//  FPUIComponent.h
//  FaustPad
//
//  Created by Ethan Kim on 10/24/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPUIComponent : UIView

@property (nonatomic, readwrite) NSInteger cid;
@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSString* varname;

- (NSString*) labelToArg;
- (void) setMin:(double)minv max:(double)maxv; // virtual function

@end
