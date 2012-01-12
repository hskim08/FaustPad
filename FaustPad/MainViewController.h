//
//  MainViewController.h
//  FaustPad
//
//  Created by Ethan on 1/11/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FPAppDelegate.h"

@interface MainViewController : UIViewController<UITextFieldDelegate> {
    
    id <MenuTabDelegate> delegate;
    
    IBOutlet UITextField* ipText;
    IBOutlet UITextField* synthText;
}

@property (retain) id delegate;

@property (nonatomic, strong) NSArray* fileList;

@property (nonatomic, strong) UITextField* ipText;
@property (nonatomic, strong) UITextField* synthText;

- (IBAction)handleAddClicked:(UIButton*)sender;

@end
