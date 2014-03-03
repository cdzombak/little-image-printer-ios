//
//  DPZPrinterManager.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZPrinter.h"

typedef void (^DPZPrinterManagerCallback)(BOOL);

@interface DPZPrinterManager : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

+ (DPZPrinterManager *)sharedPrinterManager;

- (DPZPrinter *)createPrinter;
- (void)deletePrinter:(DPZPrinter *)printer;

- (void)printImageForURL:(NSURL *)imageURL withCompletionBlock:(DPZPrinterManagerCallback)completionBlock;
- (void)printImage:(UIImage *)image withCompletionBlock:(DPZPrinterManagerCallback)completionBlock;

@property (nonatomic, strong) DPZPrinter *activePrinter;

@property (nonatomic, readonly) NSFetchedResultsController *printersFetchedResultsController;
@property (nonatomic, readonly) NSArray *printers;

@property (nonatomic, readonly) NSError *error;

@end
