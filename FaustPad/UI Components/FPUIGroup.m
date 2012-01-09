//
//  FPGroup.m
//  FaustPad
//
//  Created by Ethan Kim on 10/24/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "FPUIGroup.h"

#import <QuartzCore/QuartzCore.h>

@implementation FPUIGroup

@synthesize type;
@synthesize label = _label;
@synthesize uiLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // reset frame to zero height
        self.frame = CGRectMake(0, 0, frame.size.width, FPUI_GROUP_LABEL_HEIGHT + 2*FPUI_GROUP_INDENT);
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        // add borders
        self.layer.borderWidth = 3;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
        // create label
        uiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, FPUI_GROUP_LABEL_HEIGHT)];
        uiLabel.backgroundColor = [UIColor lightGrayColor];
        uiLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        uiLabel.textColor = [UIColor darkGrayColor];
        uiLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:uiLabel];
    }
    return self;
}

- (void) setLabel:(NSString *)label
{
    _label = label;
    uiLabel.text = label;
}

- (void) addComponent:(UIView*)component
{
    if ( [type isEqualToString:@"vgroup"] ) { // vertical layout - add height
        
        // configure sub component frame
        component.frame = CGRectMake(
                                     FPUI_GROUP_INDENT, 
                                     self.frame.size.height - FPUI_GROUP_INDENT, 
                                     self.frame.size.width - 2*FPUI_GROUP_INDENT,
                                     component.frame.size.height
                                     );
        
        // configure frame
        self.frame = CGRectMake(
                                0, 
                                0, 
                                self.frame.size.width, 
                                self.frame.size.height + component.frame.size.height
                                );
        
        // add component as subview
        [self addSubview:component];
        
    }
    else {  // horizontal layout - split width
        
        // add component as subview
        [self addSubview:component];
        
        // configure sub component frame
        int c = self.subviews.count;
        
        // reconfigure other sub components except the label
        for (int i = 1; i < c; i++) {
            UIView* view = [self.subviews objectAtIndex:i];
            view.frame = CGRectMake(
                                    (i-1)*(self.frame.size.width/(c-1)) + FPUI_GROUP_INDENT,
                                    FPUI_GROUP_LABEL_HEIGHT + FPUI_GROUP_INDENT, 
                                    self.frame.size.width/(c-1) - 2*FPUI_GROUP_INDENT,
                                    view.frame.size.height
                                    );
        }
        
        // configure frame size
        self.frame = CGRectMake(
                                0, 
                                0, 
                                self.frame.size.width,
                                fmax(self.frame.size.height, component.frame.size.height+FPUI_GROUP_LABEL_HEIGHT) + 2*FPUI_GROUP_INDENT
                                );
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    
//}


@end
