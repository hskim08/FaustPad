//
//  MainViewController.h
//  FaustPad
//
//  Created by Hyung-Suk Kim on 1/11/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//
/*-----------------------------------------------------------------------------
 Permission is hereby granted, free of charge, to any person obtaining a 
 copy of this software and associated documentation files (the "Software"), 
 to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The authors encourage users of FaustPad to include this copyright notice,
 and to let us know that you are using FaustPad. Any person wishing to 
 distribute modifications to the Software is encouraged to send the 
 modifications to the original authors so that they can be incorporated 
 into the canonical version.
 
 The Software is provided "as is", WITHOUT ANY WARRANTY, express or implied,
 including but not limited to the warranties of MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE and NONINFRINGEMENT.  In no event shall the authors
 or copyright holders by liable for any claim, damages, or other liability,
 whether in an actino of a contract, tort or otherwise, arising from, out of
 or in connection with the Software or the use or other dealings in the 
 software.
 -----------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

#import "FPAppDelegate.h"

@interface MainViewController : UIViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    
    id <MenuTabDelegate> delegate;
    
    IBOutlet UIButton* synthButton;
    IBOutlet UIPickerView* synthPickerView;
    IBOutlet UIView* popupView;
    IBOutlet UIView* settingsView;
    
    IBOutlet UITextField* ipText;
    IBOutlet UITextField* iPortText;
    IBOutlet UITextField* oPortText;    
}

@property (retain) id delegate;

@property (nonatomic, strong) NSArray* fileList;

- (IBAction)handleAddClicked:(UIButton*)sender;
- (IBAction)handleSynthTap:(UIButton*)sender;
- (IBAction)handleDoneTap:(UIButton*)sender;
- (IBAction)handleSettingsTap:(UIButton*)sender;
- (IBAction)handleSettingsDoneTap:(UIButton*)sender;

- (void) showPicker:(BOOL)show;
- (void) showSettings:(BOOL)show;

@end
