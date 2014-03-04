//
//  DPZPrinterManager.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZPrinterManager.h"

#import "DPZDataManager.h"
#import "DPZPrinter.h"

@implementation DPZPrinterManager

@synthesize printersFetchedResultsController = _printersFetchedResultsController;

+ (DPZPrinterManager *)sharedPrinterManager
{
    static DPZPrinterManager *pm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pm = [[self alloc] init];
    });
    return pm;
}

- (DPZPrinter *)createPrinter
{
    return [self insertNewObjectForEntityForName:[DPZPrinter entityName]];
}

- (void)deletePrinter:(DPZPrinter *)printer
{
    [self deleteObject:printer];
    [self saveContext];
}

- (NSArray *)printers
{
    return [self getAllFromFetchRequest:[self printersFetchRequest]];
}

- (NSFetchedResultsController *)printersFetchedResultsController
{
    if (!_printersFetchedResultsController) {
        _printersFetchedResultsController = [[NSFetchedResultsController alloc]
                                             initWithFetchRequest:[self printersFetchRequest]
                                             managedObjectContext:self.managedObjectContext
                                             sectionNameKeyPath:nil
                                             cacheName:nil];
    }
    return _printersFetchedResultsController;
}

- (NSFetchRequest *)printersFetchRequest
{
    NSFetchRequest *fr = [self newFetchRequestForEntityNamed:[DPZPrinter entityName]];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:NSStringFromSelector(@selector(name)) ascending:YES];
    fr.sortDescriptors = @[nameSort];
    return fr;
}

@end
