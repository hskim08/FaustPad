//
//  SynthViewController.h
//  FaustPad
//
//  Created by Ethan on 1/11/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DspXmlParser.h"

@interface SynthViewController : UIViewController {
    IBOutlet UIScrollView* scrollView;
}

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) DspXmlParser* dspXmlParser;
@property (nonatomic, strong) NSString* synthFile;

@property (nonatomic) NSUInteger nodeId;

- (void) createInterfaceFromXmlFile:(NSString*)xmlFile toView:(UIView*)view;
- (void) updateScrollViewSize;

@end
