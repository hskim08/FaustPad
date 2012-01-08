//
//  FPViewController.h
//  FaustPad
//
//  Created by Hyung-Suk Kim on 10/16/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "mo_net.h"
#import "DspXmlParser.h"

@interface FPViewController : UIViewController<UITextFieldDelegate> {
    
    DspXmlParser* dspXmlParser;
}

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UITextField* ipText;
@property (nonatomic, strong) UITextField* nodeText;

@end