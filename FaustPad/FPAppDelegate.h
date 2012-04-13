//
//  FPAppDelegate.h
//  FaustPad
//
//  Created by Hyung-Suk Kim on 10/16/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuTabDelegate <NSObject>
@required
- (void) addSynthTab:(NSString*)xmlFile;

@end

@protocol SynthTabDelegate <NSObject>
@required
- (void) closeSynthTab:(NSUInteger)nodeId;

@end

@interface FPAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, MenuTabDelegate, SynthTabDelegate> {
    NSUInteger maxTabs;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

- (void) addMenuTab;
- (void) addSynthTab:(NSString*)xmlFile;
- (void) closeSynthTab:(NSUInteger)nodeId;

- (void) initMoNet;

@end
