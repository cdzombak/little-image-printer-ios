//
//  DPZPrinterSelectionViewController.h
//  Little Image Printer
//
//  Created by Chris Dzombak on 3/3/14.
//  Copyright (c) 2014 David Wilkinson. All rights reserved.
//

#import "DPZFetchedResultsTableViewController.h"

@class DPZPrinter;

typedef void(^DPZPrinterSelectionCompletionBlock)(DPZPrinter *printerSelected);

@interface DPZPrinterSelectionViewController : DPZFetchedResultsTableViewController

- (instancetype)initWithCompletionBlock:(DPZPrinterSelectionCompletionBlock)completionBlock;

@end
