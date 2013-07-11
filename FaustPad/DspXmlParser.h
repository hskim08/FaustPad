//
//  DspXmlParser.h
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
@property (nonatomic, strong) NSString* name;

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
- (UIView*) createVSlider:(TBXMLElement*)element withId:(NSInteger)cid;
- (UIView*) createCheckbox:(TBXMLElement*)element withId:(NSInteger)cid;
- (UIView*) createButton:(TBXMLElement*)element withId:(NSInteger)cid;
- (UIView*) createNEntry:(TBXMLElement*)element withId:(NSInteger)cid;

- (void) parseGroup:(TBXMLElement*)element view:(UIView*)view;

- (void) parseGroup:(TBXMLElement*)element group:(FPUIGroup*)parent;
- (void) parseWidgetRef:(TBXMLElement*)element group:(FPUIGroup*)parent;

@end
