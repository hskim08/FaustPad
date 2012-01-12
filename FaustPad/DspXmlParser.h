//
//  DspXmlParser.h
//  FaustPad
//
//  Created by Hyung-Suk Kim on 10/16/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

#import "FPUIGroup.h"

@interface DspXmlParser : NSObject {
    TBXML* _tbXml;
    NSMutableArray* _widgetArray;
    UIView* _view;
    NSUInteger nodeId;
}

@property (nonatomic, strong) NSArray* componentSet;
@property (nonatomic, strong) NSArray* viewSet;

- (id) initWithUrl:(NSURL*)xmlUrl view:(UIView*)view node:(NSUInteger)nodeId;

- (void) traverseElement:(TBXMLElement*)element;

- (void) parseFaustElement:(TBXMLElement*)element;

- (void) parseUiElement:(TBXMLElement*)element;

- (void) parseActiveWidgetsElement:(TBXMLElement*)element;
- (void) parsePassiveWidgetsElement:(TBXMLElement*)element;
- (void) parseLayoutElement:(TBXMLElement*)element;

- (void) parseWidgetElement:(TBXMLElement*)element;

- (UIView*) createWidget:(NSString*)type withId:(NSInteger)cid withProperties:(TBXMLElement*)element;
- (UIView*) createHSlider:(TBXMLElement*)element withId:(NSInteger)cid;
- (UIView*) createButton:(TBXMLElement*)element withId:(NSInteger)cid;
- (UIView*) createNEntry:(TBXMLElement*)element withId:(NSInteger)cid;

- (void) parseGroup:(TBXMLElement*)element view:(UIView*)view;

- (void) parseGroup:(TBXMLElement*)element group:(FPUIGroup*)parent;
- (void) parseWidgetRef:(TBXMLElement*)element group:(FPUIGroup*)parent;

@end
