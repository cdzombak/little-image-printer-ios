//
//  UIView+DPZFirstResponder.m
//  go
//
//  Created by David Wilkinson on 08/07/2012.
//  Copyright (c) 2012 Lumen Services Limited. All rights reserved.
//

#import "UIView+DPZFirstResponder.h"

@implementation UIView (DPZFirstResponder)

- (BOOL)dpz_findAndResignFirstResponder
{
    if (self.isFirstResponder) 
    {
        [self resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in self.subviews) 
    {
        if ([subView dpz_findAndResignFirstResponder])
        return YES; 
    }
    return NO;
}

- (UIView *)dpz_findFirstResponder
{
    UIView *firstResponder = nil;
    if (self.isFirstResponder)
    {
        firstResponder = self;
    }
    if (!firstResponder)
    {
        for (UIView *subView in self.subviews)
        {
            firstResponder = [subView dpz_findFirstResponder];
            if (firstResponder)
            {
                break;
            }
        }
    }
    return firstResponder;
}

@end
