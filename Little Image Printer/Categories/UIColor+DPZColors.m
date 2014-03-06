//
//  UIColor+DPZColors.m
//  Little Image Printer
//
//  Created by Chris Dzombak on 3/5/14.
//  Copyright (c) 2014 David Wilkinson. All rights reserved.
//

#import "UIColor+DPZColors.h"

@implementation UIColor (DPZColors)

+ (UIColor *)dpz_darkBarTintColor
{
    return [UIColor colorWithWhite:0.0 alpha:0.9f];
}

+ (UIColor *)dpz_tintColor
{
    return [UIColor colorWithRed:0.839f green:0.400f blue:0.224f alpha:1];
}

+ (UIColor *)dpz_backgroundColor
{
    return [UIColor colorWithRed:0.953f green:0.941f blue:0.918f alpha:1];
}

+ (UIColor *)dpz_separatorColor
{
    return [UIColor colorWithRed:0.596f green:0.600f blue:0.600f alpha:1];
}

@end
