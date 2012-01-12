//
//  FPViewController.h
//  FaustPad
//
//  Created by Hyung-Suk Kim on 10/16/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DspXmlParser.h"

@interface FPViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UITextField* ipText;
@property (nonatomic, strong) UITextField* nodeText;

@property (nonatomic, strong) DspXmlParser* dspXmlParser;

@end