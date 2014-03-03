//
//  UIView+DPZFirstResponder.h
//  go
//
//  Created by David Wilkinson on 08/07/2012.
//  Copyright (c) 2012 Lumen Services Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DPZFirstResponder)

- (BOOL)dpz_findAndResignFirstResponder;
- (UIView *)dpz_findFirstResponder;

@end
