//
//  DPZManagePrinterViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZManagePrinterViewController.h"
#import "DPZEditPrinterViewController.h"
#import "DPZPrinterManager.h"
#import "DPZPrinter.h"

@interface DPZManagePrinterViewController ()

@property (nonatomic, readonly) UIBarButtonItem *addButton;

@end

@implementation DPZManagePrinterViewController

@synthesize addButton = _addButton;

- (id)init
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.title = NSLocalizedString(@"Printers", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.fetchedResultsController = [DPZPrinterManager sharedPrinterManager].printersFetchedResultsController;
    self.navigationItem.rightBarButtonItem = self.addButton;
}

- (UIBarButtonItem *)addButton
{
    if (!_addButton) {
        _addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPrinter:)];
    }
    return _addButton;
}

#pragma mark - UI Actions

- (void)addPrinter:(id)sender
{
    DPZEditPrinterViewController *vc = [[DPZEditPrinterViewController alloc] initWithNibName:@"DPZEditPrinterViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DPZPrinter *printer = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[DPZPrinterManager sharedPrinterManager] deletePrinter:printer];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"Forget", nil);
}

#pragma mark - DPZFetchedResultsTableViewController

- (UITableViewCell *)newCellWithReuseIdentifier:(NSString *)cellIdentifier
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DPZPrinter *printer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = printer.name;
    cell.detailTextLabel.text = printer.code;
}

@end
