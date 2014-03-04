//
//  DPZPrinter+Printing.h
//  Little Image Printer
//
//  Created by Chris Dzombak on 3/3/14.
//  Copyright (c) 2014 David Wilkinson. All rights reserved.
//

#import "DPZPrinter.h"

typedef void(^DPZPrintCompletionBlock)(BOOL success, NSError *error, id context);

@interface DPZPrinter (Printing)

/// Completion block will be called on the main queue.
- (void)printImage:(UIImage *)image context:(id)context withCompletionBlock:(DPZPrintCompletionBlock)completionBlock;

@end
