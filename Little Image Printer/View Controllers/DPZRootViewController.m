//
//  DPZRootViewController.m
//  Little Image Printer
//
//  Created by Chris Dzombak on 3/2/14.
//  Copyright (c) 2014 David Wilkinson. All rights reserved.
//

#import "DPZRootViewController.h"
#import "DPZAdjusterViewController.h"
#import "DPZManagePrinterViewController.h"
#import "DPZAboutViewController.h"
#import "DTCustomColoredAccessory.h"

@interface DPZRootViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL hasAppeared;
@property (nonatomic, readonly) BOOL canUseCamera;

@property (nonatomic, strong) UIImagePickerController *libraryPickerController;
@property (nonatomic, strong) UIImagePickerController *cameraPickerController;

@end

@implementation DPZRootViewController

- (instancetype)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.hasAppeared = NO;
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
                [wSelf takePhoto];
            }];
        }
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            staticContentCell.reuseIdentifier = defaultStyleReuseIdentifier;
            
            cell.textLabel.text = NSLocalizedString(@"Printers", nil);
            cell.imageView.image = [UIImage imageNamed:@"Settings"];
            cell.accessoryView = [DTCustomColoredAccessory accessory];
        } whenSelected:^(NSIndexPath *indexPath) {
            [wSelf managePrinters];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            staticContentCell.reuseIdentifier = defaultStyleReuseIdentifier;
            
            cell.textLabel.text = NSLocalizedString(@"About", nil);
            cell.imageView.image = [UIImage imageNamed:@"About"];
            cell.accessoryView = [DTCustomColoredAccessory accessory];
        } whenSelected:^(NSIndexPath *indexPath) {
            [wSelf about];
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
    
    if (!self.hasAppeared) {
        [self pickPhoto];
    }
    
    self.hasAppeared = YES;
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

- (void)managePrinters
{
    [self.navigationController pushViewController:[[DPZManagePrinterViewController alloc] init] animated:YES];
}

- (void)about
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
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    if (!selectedImage ) {
        return;
    }
    
    [self pushAdjusterViewControllerForImage:selectedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker == self.cameraPickerController) {
        UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
    }
}

#pragma mark - Property Overrides

- (BOOL)canUseCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

@end