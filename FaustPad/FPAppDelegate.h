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

@interface FPAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, MenuTabDelegate> {
    NSUInteger maxTabs;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

- (void) addMenuTab;
- (void) addSynthTab:(NSString*)xmlFile;

//- (void) initMoNet;

@end
