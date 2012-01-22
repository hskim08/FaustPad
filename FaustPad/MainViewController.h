//
//  MainViewController.h
//  FaustPad
//
//  Created by Ethan on 1/11/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

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
