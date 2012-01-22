//
//  SynthViewController.m
//  FaustPad
//
//  Created by Ethan on 1/11/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

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
    NSString* synthDefName = [[synthFile componentsSeparatedByString:@"."] objectAtIndex:0];
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
