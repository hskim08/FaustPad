//
//  FPUINumEntry.h
//  FaustPad
//
//  Created by Ethan Kim on 10/24/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "FPUIComponent.h"

@interface FPUINumEntry : FPUIComponent <UITextFieldDelegate>

@property (nonatomic, strong) UILabel* entryLabel;
@property (nonatomic, strong) UITextField* numEntry;

@property (nonatomic) double value;
@property (nonatomic) double minValue;
@property (nonatomic) double maxValue;

@end
