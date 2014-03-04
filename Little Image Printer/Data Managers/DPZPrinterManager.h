//
//  DPZPrinterManager.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZDataManager.h"

@class DPZPrinter;

@interface DPZPrinterManager : DPZDataManager

+ (DPZPrinterManager *)sharedPrinterManager;

@property (nonatomic, readonly) NSFetchedResultsController *printersFetchedResultsController;
@property (nonatomic, readonly) NSArray *printers;

- (DPZPrinter *)createPrinter;
- (void)deletePrinter:(DPZPrinter *)printer;

@end
