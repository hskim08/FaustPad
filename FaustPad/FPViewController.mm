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
    
    
    
    // create scroll view
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 
                                                                self.view.frame.origin.y, 
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
