//
//  FPViewController.m
//  FaustPad
//
//  Created by Hyung-Suk Kim on 10/16/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "FPViewController.h"

#import "ServerData.h"

void monetCallback( osc::ReceivedMessageArgumentStream& argument_stream, 
                     void * data )
{
    NSLog(@"Say What?");
    
    // TODO: parse message
}

@interface FPViewController(hidden) 

- (void) createInterfaceFromXmlFile:(NSString*)xmlFile toView:(UIView*)view;
- (void) initMoNet;

@end

@implementation FPViewController

@synthesize scrollView;
@synthesize ipText;
@synthesize nodeText;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // initialize mo_net
    [self initMoNet];
    
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
    nodeText.text = [NSString stringWithFormat:@"%d", [ServerData sharedInstance].nodeId];
    nodeText.delegate = self;
    [self.view addSubview:nodeText];
    
    // create scroll view
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 
                                                                25, 
                                                                self.view.frame.size.width, 
                                                                self.view.frame.size.height)];
    
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.scrollEnabled = YES;
    scrollView.clipsToBounds = YES;
    [self.view addSubview:scrollView];
	
    // load xml file
    [self createInterfaceFromXmlFile:@"bowed.dsp.xml" toView:self.scrollView];
    
    UIView* subView = [scrollView.subviews objectAtIndex:0];
    scrollView.contentSize = CGSizeMake(subView.frame.size.width, subView.frame.size.height);
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
    if (textField == nodeText) [ServerData sharedInstance].nodeId = [textField.text intValue]; 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // hide keyboard
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Private methods

- (void) createInterfaceFromXmlFile:(NSString*)xmlFile toView:(UIView*)view
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, xmlFile];
    NSURL* fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    
    // TODO: check if file exists
    
    dspXmlParser = [[DspXmlParser alloc] initWithUrl:fileURL view:view];
}

- (void) initMoNet
{
    // print out the IP of the device
    NSLog(@"IP: %s", MoNet::getMyIPaddress().c_str());
    
    // TODO: add patterns to listen for
    std::string pattern("/ding");
    MoNet::addAddressCallback( pattern, &monetCallback );
    MoNet::setListeningPort(SC_PORT_FROM);
    MoNet::startListening();
}

@end
