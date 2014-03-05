//
//  UIFont+SourceSansPro.m
//  Little Image Printer
//
//  Created by Chris Dzombak on 3/4/14.
//  Copyright (c) 2014 David Wilkinson. All rights reserved.
//

#import "UIFont+SourceSansPro.h"

@implementation UIFont (SourceSansPro)

+ (UIFont *)dpz_sourceSansProLightFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"SourceSansPro-Light" size:size];
}

+ (UIFont *)dpz_sourceSansProRegularFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"SourceSansPro-Regular" size:size];
}

@end
