//
//  FPAppDelegate.m
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

#import "FPAppDelegate.h"

#import "MainViewController.h"
#import "SynthViewController.h"

#import "mo_net.h"
#import "ServerData.h"

// MoNet callback declaration
void doneCallback( osc::ReceivedMessageArgumentStream& argument_stream, void * data );
void failCallback( osc::ReceivedMessageArgumentStream& argument_stream, void * data );

@implementation FPAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initialize mo_net
    [self initMoNet];
    
    maxTabs = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 5 : 8;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.tabBarController = [[UITabBarController alloc] init];
    
    [self addMenuTab];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    /*
//     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//     */
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    /*
//     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
//     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//     */
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    /*
//     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//     */
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    /*
//     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//     */
//}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - UI Management

- (void) addMenuTab
{
    NSMutableArray* vcArray = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
    MainViewController* vc;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        vc = [[MainViewController alloc] initWithNibName:@"MainViewController_iPhone" bundle:nil];
    }
    else {
        vc = [[MainViewController alloc] initWithNibName:@"MainViewController_iPad" bundle:nil];
    }
    [vcArray addObject:vc];
    
    vc.title = @"New";
    vc.delegate = self;
    
    self.tabBarController.viewControllers = [NSArray arrayWithArray:vcArray];
}

- (void) addSynthTab:(NSString*)xmlFile
{
    if (self.tabBarController.viewControllers.count >= maxTabs) return;
    
    // create new view controller
    SynthViewController* vc;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        vc = [[SynthViewController alloc] initWithNibName:@"SynthViewController_iPhone" bundle:nil];
    }
    else {
        vc = [[SynthViewController alloc] initWithNibName:@"SynthViewController_iPad" bundle:nil];
    }
    
    // initialize view controller
    NSString* synthDefName = [[[xmlFile componentsSeparatedByString:@"."] objectAtIndex:0] capitalizedString];
    
    vc.nodeId = [[ServerData sharedInstance] getNewNodeId];
    vc.title = [NSString stringWithFormat:@"%@: %d", synthDefName, vc.nodeId];
    vc.synthFile = xmlFile;
    vc.delegate = self;
    
    // add new tab
    NSMutableArray* vcArray = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
    [vcArray addObject:vc];
    
    self.tabBarController.viewControllers = [NSArray arrayWithArray:vcArray];
}

- (void) closeSynthTab:(NSUInteger)nodeId
{
    // find tab to close
    NSMutableArray* vcArray = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
    
    for (UIViewController* vc in vcArray) {
        if ([vc isKindOfClass:[SynthViewController class]]) {
            SynthViewController* svc = (SynthViewController*) vc;
            
            if (svc.nodeId == nodeId) {
                [vcArray removeObject:svc];
                
                // move out of view then delete
                [UIView animateWithDuration:0.5 
                                 animations:^{
                                     
                                     svc.view.frame = CGRectMake(
                                                                 0, 
                                                                 svc.view.frame.size.height, 
                                                                 svc.view.frame.size.width, 
                                                                 svc.view.frame.size.height
                                                                 );
                                 }
                                 completion:^(BOOL finished){
                                     
                                     self.tabBarController.viewControllers = [NSArray arrayWithArray:vcArray];
                                 }];
                
                return;
            }
        }
    }
    
}

#pragma mark - MoNet

- (void) initMoNet
{
    // print out the IP of the device
//    NSLog(@"IP: %s", MoNet::getMyIPaddress().c_str());
    
    // TODO: add patterns to listen for
    std::string done("/done");
    MoNet::addAddressCallback( done, &doneCallback );
    
    std::string fail("/fail");
    MoNet::addAddressCallback( fail, &failCallback );
    
    MoNet::setListeningPort([ServerData sharedInstance].inPort);
    MoNet::startListening();
}

void doneCallback( osc::ReceivedMessageArgumentStream& argument_stream, 
                  void * data )
{
    NSLog(@"Yay!");
    
    // TODO: parse message
}

void failCallback( osc::ReceivedMessageArgumentStream& argument_stream, 
                  void * data )
{
    NSLog(@"What! You FAILED!?!");
    
    // TODO: parse message
}

@end
