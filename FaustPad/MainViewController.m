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
@synthesize ipText;
@synthesize synthText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"plus"];
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
    synthText.delegate = self;
    
    // get list of files
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    self.fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    for (NSString* s in fileList) {
       // TODO: add files to picker view 
    }
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // hide keyboard
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UI event handlers

- (IBAction)handleAddClicked:(UIButton*)sender
{
    [delegate addSynthTab:synthText.text];
}

@end
