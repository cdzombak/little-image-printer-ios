//
//  DPZPrinterSelectionViewController.m
//  Little Image Printer
//
//  Created by Chris Dzombak on 3/3/14.
//  Copyright (c) 2014 David Wilkinson. All rights reserved.
//

#import "DPZPrinterSelectionViewController.h"

#import "DPZPrinterManager.h"
#import "DPZPrinter.h"

@interface DPZPrinterSelectionViewController ()

@property (nonatomic, readonly) DPZPrinterSelectionCompletionBlock completionBlock;

@end

@implementation DPZPrinterSelectionViewController

- (instancetype)initWithCompletionBlock:(DPZPrinterSelectionCompletionBlock)completionBlock
{
    NSParameterAssert(completionBlock);
    
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _completionBlock = [completionBlock copy];
        self.title = NSLocalizedString(@"Choose Printer", nil);
    }
    return self;
}

#pragma mark - DPZFetchedResultsTableViewController

- (void)resetFetchedResultsController
{
    self.fetchedResultsController = [DPZPrinterManager sharedPrinterManager].printersFetchedResultsController;
}

- (UITableViewCell *)newCellWithReuseIdentifier:(NSString *)cellIdentifier
{
    NSParameterAssert(cellIdentifier);
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(cell);
    NSParameterAssert(indexPath);
    
    DPZPrinter *printer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSAssert(printer, @"Printer must exist at %s", __PRETTY_FUNCTION__);
    
    cell.textLabel.text = printer.name;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(tableView == self.tableView);
    NSParameterAssert(indexPath);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DPZPrinter *printer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSAssert(printer, @"Printer must exist at %s", __PRETTY_FUNCTION__);
    
    self.completionBlock(printer);
}

@end
