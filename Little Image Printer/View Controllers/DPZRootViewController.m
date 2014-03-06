//
//  DPZRootViewController.m
//  Little Image Printer
//
//  Created by Chris Dzombak on 3/2/14.
//  Copyright (c) 2014 David Wilkinson. All rights reserved.
//

#import "DPZRootViewController.h"

#import "DPZAppDelegate.h"
#import "DPZPrinterManager.h"

#import "DPZAboutViewController.h"
#import "DPZAdjusterViewController.h"
#import "DPZBergRemoteViewController.h"
#import "DPZEditPrinterViewController.h"
#import "DPZManagePrinterViewController.h"

#import "DTCustomColoredAccessory.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface DPZRootViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, readonly) BOOL canUseCamera;
@property (nonatomic, assign) BOOL hasCheckedAndPresentedAddView;

@property (nonatomic, strong) UIImagePickerController *libraryPickerController;
@property (nonatomic, strong) UIImagePickerController *cameraPickerController;

@property (nonatomic, strong) UIImage *chosenImage;

@end

@implementation DPZRootViewController

- (instancetype)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = NSLocalizedString(@"Little Photo Printer", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.libraryPickerController = ({
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker;
    });
    
    if (self.canUseCamera) {
        self.cameraPickerController = ({
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker;
        });
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Home", nil) style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    static NSString * const defaultStyleReuseIdentifier = @"Cell";
    self.tableView.rowHeight = 50;
    __weak __typeof(self) wSelf = self;
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            staticContentCell.reuseIdentifier = defaultStyleReuseIdentifier;
            
            cell.textLabel.text = NSLocalizedString(@"Choose Photo", nil);
            cell.imageView.image = [UIImage imageNamed:@"Photo Library"];
            cell.accessoryView = [DTCustomColoredAccessory accessory];
        } whenSelected:^(NSIndexPath *indexPath) {
            [wSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [wSelf pickPhoto];
        }];

        if (wSelf.canUseCamera) {
            [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                staticContentCell.cellStyle = UITableViewCellStyleDefault;
                staticContentCell.reuseIdentifier = defaultStyleReuseIdentifier;
                
                cell.textLabel.text = NSLocalizedString(@"Take Photo", nil);
                cell.imageView.image = [UIImage imageNamed:@"Camera"];
                cell.accessoryView = [DTCustomColoredAccessory accessory];
            } whenSelected:^(NSIndexPath *indexPath) {
                [wSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
                [wSelf takePhoto];
            }];
        }
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            staticContentCell.reuseIdentifier = defaultStyleReuseIdentifier;
            
            cell.textLabel.text = NSLocalizedString(@"Berg Remote", nil);
            cell.imageView.image = [UIImage imageNamed:@"Remote"];
            cell.accessoryView = [DTCustomColoredAccessory accessory];
        } whenSelected:^(NSIndexPath *indexPath) {
            [wSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [wSelf showBergRemote];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            staticContentCell.reuseIdentifier = defaultStyleReuseIdentifier;
            
            cell.textLabel.text = NSLocalizedString(@"Printers", nil);
            cell.imageView.image = [UIImage imageNamed:@"Settings"];
            cell.accessoryView = [DTCustomColoredAccessory accessory];
        } whenSelected:^(NSIndexPath *indexPath) {
            [wSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [wSelf managePrinters];
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            staticContentCell.reuseIdentifier = defaultStyleReuseIdentifier;
            
            cell.textLabel.text = NSLocalizedString(@"About", nil);
            cell.imageView.image = [UIImage imageNamed:@"About"];
            cell.accessoryView = [DTCustomColoredAccessory accessory];
        } whenSelected:^(NSIndexPath *indexPath) {
            [wSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [wSelf showAbout];
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.hasCheckedAndPresentedAddView && ![DPZPrinterManager sharedPrinterManager].printers.count) {
        DPZEditPrinterViewController *editPrinterVC = [[DPZEditPrinterViewController alloc] initWithPrinter:nil];
        [self.navigationController pushViewController:editPrinterVC animated:YES];
    }
    
    self.hasCheckedAndPresentedAddView = YES;
}

#pragma mark - UI Events

- (void)takePhoto
{
    [self presentViewController:self.cameraPickerController animated:YES completion:nil];
}

- (void)pickPhoto
{
    [self presentViewController:self.libraryPickerController animated:YES completion:nil];
}

- (void)showBergRemote
{
    if (![(DPZAppDelegate *)[UIApplication sharedApplication].delegate isCloudReachable]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Offline", nil)];
    } else {
        [self.navigationController pushViewController:[[DPZBergRemoteViewController alloc] initWithURL:nil] animated:YES];
    }
}

- (void)managePrinters
{
    [self.navigationController pushViewController:[[DPZManagePrinterViewController alloc] init] animated:YES];
}

- (void)showAbout
{
    [self.navigationController pushViewController:[[DPZAboutViewController alloc] init] animated:YES];
}

- (void)pushAdjusterViewControllerForImage:(UIImage *)image
{
    DPZAdjusterViewController *vc = [[DPZAdjusterViewController alloc] initWithSourceImage:image];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL isFirstChosenImage = (self.chosenImage == nil);
    
    self.chosenImage = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    if (!self.chosenImage ) {
        return;
    }
    
    [self pushAdjusterViewControllerForImage:self.chosenImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker == self.cameraPickerController) {
        UIImageWriteToSavedPhotosAlbum(self.chosenImage, nil, nil, nil);
    }
    
    if (isFirstChosenImage) {
        [self insertCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            staticContentCell.reuseIdentifier = @"Cell";
            
            cell.textLabel.text = NSLocalizedString(@"Last Photo", nil);
            cell.imageView.image = [UIImage imageNamed:@"Last Chosen"];
            cell.accessoryView = [DTCustomColoredAccessory accessory];
        } whenSelected:^(NSIndexPath *indexPath) {
            [self pushAdjusterViewControllerForImage:self.chosenImage];
        } atIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES];
    }
}

#pragma mark - Property Overrides

- (BOOL)canUseCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

@end
