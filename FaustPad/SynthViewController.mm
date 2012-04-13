//
//  SynthViewController.m
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

#import "SynthViewController.h"

#import "mo_net.h"
#import "ServerData.h"

#import "FormattedNSLogger.h"

@implementation SynthViewController

@synthesize delegate;

@synthesize scrollView;
@synthesize dspXmlParser;
@synthesize synthFile;

@synthesize nodeId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"play"];
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
    
    scrollView.clipsToBounds = YES;
    
    [self createInterfaceFromXmlFile:synthFile toView:scrollView];
    
    // pull close button forward
    [self.scrollView bringSubviewToFront:closeButton];
    
    // create synth, assuming SynthDefs are loaded
    NSString* synthDefName = dspXmlParser.name;//[[synthFile componentsSeparatedByString:@"."] objectAtIndex:0];
    //[[[synthFile componentsSeparatedByString:@"."] objectAtIndex:0] capitalizedString];
    
    // hide view
    scrollView.frame = CGRectMake(
                                  0, 
                                  scrollView.frame.size.height, 
                                  scrollView.frame.size.width, 
                                  scrollView.frame.size.height
                                  );
    
    // popup from below
    [UIView animateWithDuration:0.5 
                     animations:^{
                         scrollView.frame = CGRectMake(
                                                       0, 
                                                       0, 
                                                       scrollView.frame.size.width, 
                                                       scrollView.frame.size.height
                                                       );

                     }];
    
    // send OSC message
    NSLog(@"/s_new: %@", synthDefName);
    char types[2] = {'s', 'i'};
    MoNet::sendMessage( 
                       std::string([[ServerData sharedInstance].serverIp cStringUsingEncoding:NSUTF8StringEncoding]), 
                       SC_PORT_TO, 
                       std::string("/s_new"), 
                       types, 
                       2,
                       [synthDefName cStringUsingEncoding:NSUTF8StringEncoding],
                       nodeId
                       );
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

- (void) createInterfaceFromXmlFile:(NSString*)xmlFile toView:(UIView*)view
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, xmlFile];
    NSURL* fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    
    dspXmlParser = [[DspXmlParser alloc] initWithUrl:fileURL view:view node:self.nodeId];
    
    UIView* subview = [scrollView.subviews lastObject];
    [self updateScrollViewSize];
    
    [subview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void) updateScrollViewSize
{
    CGSize size = CGSizeMake(0, 0);
    for (UIView* view in scrollView.subviews) {
        if (size.width < view.frame.size.width) {
            size.width = view.frame.size.width;
        }
        
        if (size.height < view.frame.size.height) {
            size.height = view.frame.size.height;
        }
    }

    scrollView.contentSize = size;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if( [keyPath isEqualToString:@"frame"] ) {
        [self updateScrollViewSize];
    }
}

- (IBAction)handleCloseTap:(UIButton*)sender
{
    // send OSC message
    NSLog(@"/n_free: %d", nodeId);
    char types[1] = { 'i'};
    MoNet::sendMessage( 
                       std::string([[ServerData sharedInstance].serverIp cStringUsingEncoding:NSUTF8StringEncoding]), 
                       [ServerData sharedInstance].outPort, 
                       std::string("/n_free"), 
                       types, 
                       1,
                       nodeId
                       );
    
    // remove observer
    for (UIView* view in scrollView.subviews) {
        if ([view isKindOfClass:[FPUIGroup class]]) {
            [view removeObserver:self forKeyPath:@"frame"];
        }
    }
    
    // call delegate
    [delegate closeSynthTab:nodeId];
}

@end
