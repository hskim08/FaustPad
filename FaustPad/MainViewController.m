//
//  MainViewController.m
//  FaustPad
//
//  Created by Ethan on 1/11/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "MainViewController.h"
#import "ServerData.h"

@implementation MainViewController
@synthesize delegate;
@synthesize fileList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"doc"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ipText.delegate = self;
    oPortText.delegate = self;
    iPortText.delegate = self;
    synthPickerView.delegate = self;
    
    // hide picker
    popupView.hidden = YES;
    [self.view addSubview:popupView];
    settingsView.hidden = YES;
    [self.view addSubview:settingsView];
    
    // get list of files
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    self.fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    // initialize synth button. TODO: handle empty case
    [synthButton setTitle:[fileList objectAtIndex:0] forState:UIControlStateNormal];
    
    // load server settings
    [[ServerData sharedInstance] loadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // TODO: validate inputs
    
    if (textField == ipText) {
        
        [ServerData sharedInstance].serverIp = textField.text;
    } 
    else if (textField == oPortText) {
        
        [ServerData sharedInstance].outPort = textField.text.intValue;
    }
    else if (textField == iPortText) {
        
        [ServerData sharedInstance].inPort = textField.text.intValue;
    }
    
    [[ServerData sharedInstance] saveData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // hide keyboard
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return fileList.count;
}

#pragma mark - UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    return [fileList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{    
    [synthButton setTitle:[fileList objectAtIndex:row] forState:UIControlStateNormal];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat value = 0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        value = self.view.frame.size.width;
    } 
    else {
        value = 320;
    }
    return value;
}

#pragma mark - UI event handlers

- (IBAction)handleAddClicked:(UIButton*)sender
{
    [delegate addSynthTab:[synthButton titleForState:UIControlStateNormal]];
}

- (IBAction)handleSynthTap:(UITextField*)sender
{
    [self showPicker:popupView.hidden];
}

- (IBAction)handleDoneTap:(UIButton*)sender
{
    [self showPicker:popupView.hidden];
}

- (IBAction)handleSettingsTap:(UIButton*)sender
{
    [self showSettings:settingsView.hidden];
}

- (IBAction)handleSettingsDoneTap:(UIButton*)sender
{
    [self showSettings:settingsView.hidden];
}

- (void) showPicker:(BOOL)show
{
    UIView* view = popupView;
    if (show) { // show
        // move picker to lowest position and show
        view.frame = CGRectMake(
                                           0, 
                                           self.view.frame.size.height, 
                                           self.view.frame.size.width, 
                                           view.frame.size.height
                                           );
        
        view.hidden = NO;
        
        // show picker
        [UIView animateWithDuration:0.3 animations:^{
            
            view.frame = CGRectMake(
                                               0, 
                                               self.view.frame.size.height-view.frame.size.height, 
                                               self.view.frame.size.width, 
                                               view.frame.size.height
                                               );
        }];
    }
    else { // hide
        
        [UIView animateWithDuration:0.3 
                         animations:^{
                             view.frame = CGRectMake(
                                                                0, 
                                                                self.view.frame.size.height, 
                                                                self.view.frame.size.width, 
                                                                view.frame.size.height
                                                                );
                         } 
                         completion:^(BOOL finished) {
                             view.hidden = YES;
                             
                         }];
    }
}

- (void) showSettings:(BOOL)show
{
    UIView* view = settingsView;
    if (show) { // show
        
        // update state from ServerData
        ipText.text = [ServerData sharedInstance].serverIp;
        iPortText.text = [NSString stringWithFormat:@"%d", [ServerData sharedInstance].inPort] ;
        oPortText.text = [NSString stringWithFormat:@"%d", [ServerData sharedInstance].outPort] ;
        
        // move picker to lowest position and show
        view.frame = CGRectMake(
                                0, 
                                self.view.frame.size.height, 
                                self.view.frame.size.width, 
                                view.frame.size.height
                                );
        
        view.hidden = NO;
        
        // show picker
        [UIView animateWithDuration:0.3 animations:^{
            
            view.frame = CGRectMake(
                                    0, 
                                    0, 
                                    self.view.frame.size.width, 
                                    view.frame.size.height
                                    );
        }];
    }
    else { // hide
        
        [UIView animateWithDuration:0.3 
                         animations:^{
                             view.frame = CGRectMake(
                                                     0, 
                                                     self.view.frame.size.height, 
                                                     self.view.frame.size.width, 
                                                     view.frame.size.height
                                                     );
                         } 
                         completion:^(BOOL finished) {
                             view.hidden = YES;
                             
                         }];
    }}

@end
