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
#import "DTCustomColoredAccessory.h"

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
    
    self.navigationItem.rightBarButtonItem = self.addButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
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
    DPZEditPrinterViewController *vc = [[DPZEditPrinterViewController alloc] initWithPrinter:nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DPZPrinter *printer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    DPZEditPrinterViewController *editPrinterVC = [[DPZEditPrinterViewController alloc] initWithPrinter:printer];
    [self.navigationController pushViewController:editPrinterVC animated:YES];
}

#pragma mark - DPZFetchedResultsTableViewController

- (void)resetFetchedResultsController
{
    self.fetchedResultsController = [DPZPrinterManager sharedPrinterManager].printersFetchedResultsController;
}

- (UITableViewCell *)newCellWithReuseIdentifier:(NSString *)cellIdentifier
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DPZPrinter *printer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = printer.name;
    cell.detailTextLabel.text = printer.code;
    cell.accessoryView = [DTCustomColoredAccessory accessory];
}

@end
