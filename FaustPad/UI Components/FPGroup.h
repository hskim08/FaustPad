//
//  FPGroup.h
//  FaustPad
//
//  Created by Ethan Kim on 10/24/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FPUIComponent.h"

#define FP_GROUP_LABEL_HEIGHT 30
#define FP_GROUP_INDENT 20

@interface FPGroup : UIView

@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) UILabel* uiLabel;

- (void) addComponent:(UIView*)component;

@end
