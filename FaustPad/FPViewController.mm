//
//  FPViewController.m
//  FaustPad
//
//  Created by Hyung-Suk Kim on 10/16/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
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

#import "FPViewController.h"

#import "mo_net.h"

#import "ServerData.h"

@interface FPViewController(hidden) 

- (void) initSubViews;
- (void) createInterfaceFromXmlFile:(NSString*)xmlFile toView:(UIView*)view;

@end

@implementation FPViewController

@synthesize scrollView;
@synthesize ipText;
@synthesize nodeText;

@synthesize dspXmlParser;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // initialize sub views
    [self initSubViews];
    	
    // load xml file
    NSString* synthDefName = @"bowed";
    NSString* xmlFilename = [NSString stringWithFormat:@"%@.dsp.xml", [synthDefName lowercaseString]];
    [self createInterfaceFromXmlFile:xmlFilename toView:self.scrollView];
    
    UIView* subView = [scrollView.subviews objectAtIndex:0];
    scrollView.contentSize = CGSizeMake(subView.frame.size.width, subView.frame.size.height+2*FPUI_GROUP_INDENT);
    
    // create synth, assuming SynthDefs are loaded
    // send OSC message
    char types[2] = {'s', 'i'};
    MoNet::sendMessage( 
                       std::string([[ServerData sharedInstance].serverIp cStringUsingEncoding:NSUTF8StringEncoding]), 
                       SC_PORT_TO, 
                       std::string("/s_new"), 
                       types, 
                       2,
                       [synthDefName cStringUsingEncoding:NSUTF8StringEncoding],
                       [ServerData sharedInstance].nodeAssign
                       );
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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
    
    if (textField == ipText) [ServerData sharedInstance].serverIp = textField.text;
    if (textField == nodeText) [ServerData sharedInstance].nodeAssign = [textField.text intValue]; 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // hide keyboard
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Private methods

- (void) initSubViews
{
    // add IP input
    UILabel* ipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    ipLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    ipLabel.textColor = [UIColor lightGrayColor];
    ipLabel.text = @"IP: ";
    [self.view addSubview:ipLabel];
    
    ipText = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, self.view.frame.size.width/4-30, 25)];
    ipText.clearButtonMode = UITextFieldViewModeWhileEditing;
    ipText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    ipText.backgroundColor = [UIColor whiteColor];
    ipText.text = [ServerData sharedInstance].serverIp;
    ipText.delegate = self;
    [self.view addSubview:ipText];
    
    // add node input
    UILabel* nodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, 0, 75, 25)];
    nodeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    nodeLabel.textColor = [UIColor lightGrayColor];
    nodeLabel.text = @"NodeID: ";
    [self.view addSubview:nodeLabel];
    
    nodeText = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4+75, 0, self.view.frame.size.width/4-75, 25)];
    nodeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    nodeText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    nodeText.backgroundColor = [UIColor whiteColor];
    nodeText.text = [NSString stringWithFormat:@"%d", [ServerData sharedInstance].nodeAssign];
    nodeText.delegate = self;
    [self.view addSubview:nodeText];
    
    // create scroll view
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 
                                                                25, 
                                                                self.view.frame.size.width, 
                                                                self.view.frame.size.height)];
    
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.scrollEnabled = YES;
    scrollView.clipsToBounds = YES;
    [self.view addSubview:scrollView];
    
}

- (void) createInterfaceFromXmlFile:(NSString*)xmlFile toView:(UIView*)view
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, xmlFile];
    NSURL* fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    
    dspXmlParser = [[DspXmlParser alloc] initWithUrl:fileURL view:view node:[ServerData sharedInstance].nodeAssign];
}

@end
