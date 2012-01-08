//
//  FPGroup.m
//  FaustPad
//
//  Created by Ethan Kim on 10/24/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "FPUIGroup.h"

@implementation FPUIGroup

@synthesize type;
@synthesize label = _label;
@synthesize uiLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        uiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, FPUI_GROUP_LABEL_HEIGHT)];
        uiLabel.backgroundColor = [UIColor lightGrayColor];
        uiLabel.textColor = [UIColor darkGrayColor];
        uiLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:uiLabel];
        
//        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
        // reposition component
        component.frame = CGRectMake(
                                     0, 
                                     self.frame.size.height, 
                                     component.frame.size.width,
                                     component.frame.size.height
                                     );
        
        // resize frame
        self.frame = CGRectMake(
                                0, 
                                0, 
                                fmax(self.frame.size.width, component.frame.size.width), 
                                self.frame.size.height + component.frame.size.height);
    }
    else {  // horizontal layout - split width
        // reposition component
        component.frame = CGRectMake(
                                     self.frame.size.width, 
                                     FPUI_GROUP_LABEL_HEIGHT, 
                                     component.frame.size.width, 
                                     component.frame.size.height
                                     );
        
        // resize frame
        self.frame = CGRectMake(
                                0, 
                                0, 
                                self.frame.size.width + component.frame.size.width, 
                                fmax(self.frame.size.height, component.frame.size.height+FPUI_GROUP_LABEL_HEIGHT)
                                );
    }
    
    // add component as subview
    [self addSubview:component];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    
//}


@end
