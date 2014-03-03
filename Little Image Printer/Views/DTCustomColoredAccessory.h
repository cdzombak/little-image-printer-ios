//
//  DTCustomColoredAccessory.h
//  Little Image Printer
//
//  Created by Chris Dzombak on 3/3/14.
//  Copyright (c) 2014 David Wilkinson. All rights reserved.
//
// from http://www.cocoanetics.com/2010/10/custom-colored-disclosure-indicators/ , modified for ARC and auto property synthesis
//

@interface DTCustomColoredAccessory : UIControl

@property (nonatomic, strong) UIColor *accessoryColor;
@property (nonatomic, strong) UIColor *highlightedColor;

+ (instancetype)accessory;
+ (instancetype)accessoryWithColor:(UIColor *)color;

@end
