//
//  DspXmlParser.m
//  FaustPad
//
//  Created by Hyung-Suk Kim on 10/16/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "DspXmlParser.h"

#import "FPUIHSlider.h"
#import "FPUIButton.h"
#import "FPUINumEntry.h"


@implementation DspXmlParser

@synthesize componentSet;
@synthesize viewSet;
@synthesize name;


- (id) initWithUrl:(NSURL*)xmlUrl view:(UIView *)view node:(NSUInteger)ni {

    self = [super init];
    
    if ( self != nil ) {
        _view = view;
        nodeId = ni;
        
        NSLog(@"Parsing: %@", xmlUrl.absoluteString.lastPathComponent);

        // load and parse the xml file
        _tbXml = [TBXML tbxmlWithURL:xmlUrl];
        [self parseFaustElement:_tbXml.rootXMLElement];
//        [self traverseElement:_tbXml.rootXMLElement];
    }
    
    return self;
}


// parses <faust> element
- (void) parseFaustElement:(TBXMLElement*)element
{
    NSLog(@"Parsing <faust>");
    
    // traverse child nodes
    TBXMLElement* child = element->firstChild;
    
    do {
        if ( [[TBXML elementName:child] isEqualToString:@"name"] ) { // parse name
            
            NSString* nameElement = [TBXML textForElement:child];
            name = [NSString stringWithFormat:@"faust%@", [nameElement stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
        else if ( [[TBXML elementName:child] isEqualToString:@"ui"] ) [self parseUiElement:child];
        
    } while ( (child = child->nextSibling) );
}


// parses <ui> element
- (void) parseUiElement:(TBXMLElement*)element
{
    NSLog(@"Parsing <ui>");
    
    TBXMLElement* active = element->firstChild;
    [self parseActiveWidgetsElement:active];
    
    TBXMLElement* passive = active->nextSibling;
    [self parsePassiveWidgetsElement:passive];
    
    TBXMLElement* layout = passive->nextSibling;
    [self parseLayoutElement:layout];
}


// parses <activewidgets>
- (void) parseActiveWidgetsElement:(TBXMLElement*)element
{
    NSLog(@"Parsing <activewidgets>");
    
    TBXMLElement* count = element->firstChild;
    NSInteger activeCount = [TBXML textForElement:count].integerValue;
    NSLog(@"count: %d", activeCount);
    _widgetArray = [NSMutableArray array];
    
    // parse widgets
    TBXMLElement* widget = count->nextSibling;
    do {
        
        [self parseWidgetElement:widget];
    } while ( (widget = widget->nextSibling) );
}


// parses <widget>
- (void) parseWidgetElement:(TBXMLElement*)element
{
    // parse type and id#
    TBXMLAttribute* wType = element->firstAttribute;
    TBXMLAttribute* wId = wType->next;
    
    NSString* typeString = [TBXML attributeValue:wType];
    NSInteger idInt = [TBXML attributeValue:wId].integerValue;
    
    // create ui component
    UIView* widget = [self createWidget:typeString withId:idInt withProperties:element->firstChild];
    
    if (widget) {
        
        [_widgetArray addObject:widget];
        NSLog(@"array size: %d", _widgetArray.count);
    }
    
}


// creates a widget
- (UIView*) createWidget:(NSString*)type withId:(NSInteger)cid withProperties:(TBXMLElement*)element
{
    if ( [type isEqualToString:@"hslider"] ) return [self createHSlider:element withId:cid];
    else if ( [type isEqualToString:@"button"] ) return [self createButton:element withId:cid];
    else if ( [type isEqualToString:@"nentry"] ) return [self createNEntry:element withId:cid];
    return nil;
}


// creates a hslider
- (UIView*) createHSlider:(TBXMLElement*)element withId:(NSInteger)cid
{
    // create slider
    FPUIHSlider* slider = [[FPUIHSlider alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    slider.nodeId = nodeId;
    
    // set values
    TBXMLElement* label = element;
    TBXMLElement* varname = label->nextSibling;
    TBXMLElement* initValue = varname->nextSibling;
    TBXMLElement* minValue = initValue->nextSibling;
    TBXMLElement* maxValue = minValue->nextSibling;
//    TBXMLElement* stepValue = maxValue->nextSibling;
    
    slider.cid = cid;
    slider.label = [TBXML textForElement:label];
    slider.varname = [TBXML textForElement:varname];
    
    [slider setMin:[TBXML textForElement:minValue].doubleValue 
               max:[TBXML textForElement:maxValue].doubleValue];
    slider.slider.value = [TBXML textForElement:initValue].doubleValue;
    
    NSLog(@"Created hslider(%@, %d) with (min/max/val): %.2f/%.2f/%.2f", 
          slider.label, cid, slider.slider.minimumValue, slider.slider.maximumValue, slider.slider.value);
    
    return slider;
}


// creates a button
- (UIView*) createButton:(TBXMLElement*)element withId:(NSInteger)cid
{
    FPUIButton* button = [[FPUIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    button.nodeId = nodeId;
    
    TBXMLElement* label = element;
    TBXMLElement* varname = label->nextSibling;

    button.cid = cid;
    button.label = [TBXML textForElement:label];
    button.varname = [TBXML textForElement:varname];
    
    NSLog(@"Created button(%@, %d)", button.label, cid);
    
    return button;
}


// creates a number entry
- (UIView*) createNEntry:(TBXMLElement*)element withId:(NSInteger)cid
{
    FPUINumEntry* numEntry = [[FPUINumEntry alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    numEntry.nodeId = nodeId;
    
    TBXMLElement* label = element;
    TBXMLElement* varname = label->nextSibling;
    TBXMLElement* initValue = varname->nextSibling;
    TBXMLElement* minValue = initValue->nextSibling;
    TBXMLElement* maxValue = minValue->nextSibling;
//    TBXMLElement* stepValue = maxValue->nextSibling;
    
    numEntry.cid = cid;
    numEntry.label = [TBXML textForElement:label];
    numEntry.varname = [TBXML textForElement:varname];
    
    [numEntry setMin:[TBXML textForElement:minValue].doubleValue 
                 max:[TBXML textForElement:maxValue].doubleValue];
    numEntry.value = [TBXML textForElement:initValue].doubleValue;
    
    
    NSLog(@"Created numEntry (%@, %d)", numEntry.label, cid);
    
    return numEntry;
}


// parses <passivewidgets>
- (void) parsePassiveWidgetsElement:(TBXMLElement*)element
{
    NSLog(@"Parsing <passivewidgets>");
}


// parses <layout>
- (void) parseLayoutElement:(TBXMLElement*)element
{
    NSLog(@"Parsing <layout>");
    
    TBXMLElement* group = element->firstChild;
    do {
        
        [self parseGroup:group view:_view];
    } while ( (group = group->nextSibling) );
}


// parses <group> to add to view
- (void) parseGroup:(TBXMLElement*)element view:(UIView*)view
{
    NSLog(@"view frame: %f/%f/%f/%f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    // create group
    FPUIGroup* group = [[FPUIGroup alloc] initWithFrame:view.frame];
    
    // get type
    NSString* type = [TBXML attributeValue:element->firstAttribute];
    group.type = type;
    
    // get label
    TBXMLElement* child = element->firstChild;
    [group setLabel:[TBXML textForElement:child]];
    
    NSLog(@"Creating group %@ of type %@", group.label, group.type);
    
    // parse components
    while ( (child = child->nextSibling) ) {
        
        NSString* component = [TBXML elementName:child];
        
        if ( [component isEqualToString:@"group"] ) {
            [self parseGroup:child group:group];
        }
        else if ( [component isEqualToString:@"widgetref"] ) {
            [self parseWidgetRef:child group:group];
        }
    }
    
    [view addSubview:group];
}


// parses <group> to add to FPGroup
- (void) parseGroup:(TBXMLElement*)element group:(FPUIGroup*)parent
{
    // create group
    FPUIGroup* group = [[FPUIGroup alloc] initWithFrame:parent.frame];
    
    // get type
    NSString* type = [TBXML attributeValue:element->firstAttribute];
    group.type = type;
    
    // get label
    TBXMLElement* child = element->firstChild;
    group.label = [TBXML textForElement:child];
    
    NSLog(@"Creating group %@ of type %@", group.label, group.type);
    
    // parse components
    while ( (child = child->nextSibling) ) {
        
        NSString* component = [TBXML elementName:child];
        
        if ( [component isEqualToString:@"group"] ) {
            [self parseGroup:child group:group];
        }
        else if ( [component isEqualToString:@"widgetref"] ) {
            [self parseWidgetRef:child group:group];
        }
    }
    
    [parent addComponent:group];
}
             
- (void) parseWidgetRef:(TBXMLElement*)element group:(FPUIGroup*)parent
{
    NSInteger cid = [TBXML attributeValue:element->firstAttribute].integerValue;
    
    NSLog(@"Adding widget # %d", cid);
    FPUIComponent* component = [_widgetArray objectAtIndex:(cid-1)];
    
    [parent addComponent:component];
}


// general method for traversing an xml tree
- (void) traverseElement:(TBXMLElement *)element 
{
	do {
		// Display the name of the element
        if ([TBXML textForElement:element].length > 0 ) {
            
            NSLog(@"%@: %@", [TBXML elementName:element], [TBXML textForElement:element]);
        } 
        else {
            
            NSLog(@"%@", [TBXML elementName:element]);
        }
    	
		// Obtain first attribute from element
		TBXMLAttribute * attribute = element->firstAttribute;
		
		// if attribute is valid
		while (attribute) {
			// Display name and value of attribute to the log window
			NSLog(@"%@->%@ = %@",[TBXML elementName:element],[TBXML attributeName:attribute], [TBXML attributeValue:attribute]);
			
			// Obtain the next attribute
			attribute = attribute->next;
		}
		
		// if the element has child elements, process them
		if ( element->firstChild ) [self traverseElement:element->firstChild];
        
        // Obtain next sibling element
	} while ((element = element->nextSibling));  
}

@end
