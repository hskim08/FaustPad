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
@synthesize triangleButton;
@synthesize contentShowing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        contentShowing = YES;
        
        // reset frame to zero height
        self.frame = CGRectMake(0, 0, frame.size.width, FPUI_GROUP_LABEL_HEIGHT + 2*FPUI_GROUP_INDENT);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | 
                                UIViewAutoresizingFlexibleLeftMargin | 
                                UIViewAutoresizingFlexibleRightMargin;
        self.clipsToBounds = YES;
        
        // add borders
        self.layer.borderWidth = 3;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
        // create label
        uiLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                            FPUI_GROUP_LABEL_HEIGHT,
                                                            0,
                                                            frame.size.width-FPUI_GROUP_LABEL_HEIGHT, 
                                                            FPUI_GROUP_LABEL_HEIGHT
                                                            )];
        uiLabel.backgroundColor = [UIColor lightGrayColor];
        uiLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        uiLabel.textColor = [UIColor darkGrayColor];
        uiLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:uiLabel];
        
        // create minimize button
        triangleButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangle.png"]];
        triangleButton.frame = CGRectMake(
                                          0, 
                                          0, 
                                          FPUI_GROUP_LABEL_HEIGHT, 
                                          FPUI_GROUP_LABEL_HEIGHT
                                          );
        triangleButton.userInteractionEnabled = YES;
        [self addSubview:triangleButton];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [triangleButton addGestureRecognizer:tap];
        
    }
    return self;
}

- (void) setLabel:(NSString *)label
{
    _label = label;
    uiLabel.text = label;
}

- (void) layoutSubviews
{
    if (!contentShowing) return;
    
    if ( [self.type isEqualToString:@"vgroup"] ) { // vertical layout
       
        [UIView animateWithDuration:0.5 animations:^{
            
            float currY = FPUI_GROUP_LABEL_HEIGHT+FPUI_GROUP_INDENT;
            
            int c = self.subviews.count-2;
            for (int i = 0; i < c; i++) {
                FPUIComponent* view = [self.subviews objectAtIndex:(i+2)];
                
                view.frame = CGRectMake(
                                        view.frame.origin.x, 
                                        currY, 
                                        view.frame.size.width, 
                                        view.frame.size.height
                                        );
                
                currY += view.frame.size.height;
            }
            
            // configure frame size
            self.frame = CGRectMake(
                                    self.frame.origin.x, 
                                    self.frame.origin.y, 
                                    self.frame.size.width,
                                    currY + FPUI_GROUP_INDENT
                                    );
        }];
        
        
    } 
    else {  // horizontal layout
        [UIView animateWithDuration:0.5 animations:^{
            
            // find the new max height
            float newHeight = 0;
            
            int c = self.subviews.count-2;
            for (int i = 0; i < c; i++) {
                FPUIComponent* view = [self.subviews objectAtIndex:(i+2)];
                
                newHeight = fmaxf(newHeight, view.frame.size.height);
            }
            
            // configure frame size
            self.frame = CGRectMake(
                                    self.frame.origin.x, 
                                    self.frame.origin.y, 
                                    self.frame.size.width,
                                    newHeight + FPUI_GROUP_LABEL_HEIGHT + 2*FPUI_GROUP_INDENT
                                    );
        }];

    }
    
    [self.superview setNeedsLayout];
}

- (void) addComponent:(UIView*)component
{
    // add component as subview
    [self addSubview:component];
    
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
        
    }
    else {  // horizontal layout - split width
        
        // configure sub component frame
        int c = self.subviews.count-2;
        
        // reconfigure sub components except the label
        for (int i = 0; i < c; i++) {
            UIView* view = [self.subviews objectAtIndex:(i+2)];
            view.frame = CGRectMake(
                                    i*(self.frame.size.width/c) + FPUI_GROUP_INDENT,
                                    FPUI_GROUP_LABEL_HEIGHT + FPUI_GROUP_INDENT, 
                                    self.frame.size.width/c - 2*FPUI_GROUP_INDENT,
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
    
    // save full frame height
    height = self.frame.size.height;
}

- (void) handleTap:(UITapGestureRecognizer*)sender
{
    if (contentShowing) {
        
        contentShowing = NO;
        [UIView animateWithDuration:0.5 animations:^{
            
            // hide group panel
            triangleButton.transform = CGAffineTransformMakeRotation(M_PI);
            self.frame = CGRectMake(
                                    self.frame.origin.x, 
                                    self.frame.origin.y, 
                                    self.frame.size.width, 
                                    FPUI_GROUP_LABEL_HEIGHT
                                    );
        }];
    }
    else {
        
        contentShowing = YES;
        [UIView animateWithDuration:0.5 animations:^{
            
            triangleButton.transform = CGAffineTransformIdentity;
            
            // there is no need to resize here.
            // the superview will call layoutsubview for this view
        }];
    }
    
    [self.superview setNeedsLayout];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    
//}


@end
