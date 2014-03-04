//
//  DPZAdjusterViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZAdjusterViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <GPUImage/GPUImage.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <WYPopoverController/WYPopoverController.h>

#import "DPZAppDelegate.h"
#import "DPZImageProcessor.h"
#import "DPZPrinterSelectionViewController.h"
#import "DPZPrinter+Printing.h"

static const CGFloat LittlePrinterWidth = 384.0f;

@interface DPZAdjusterViewController ()

@property (nonatomic, strong) DPZImageProcessor *imageProcessor;

@property (nonatomic, strong) IBOutlet UISlider *brightness;
@property (nonatomic, strong) IBOutlet UISlider *contrast;
@property (nonatomic, strong) IBOutlet UIView *imageViewHolder;
@property (nonatomic, strong) IBOutlet UIView *adjustmentsViewHolder;

@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) GPUImageBrightnessFilter *brightnessFilter;
@property (nonatomic, strong) GPUImageContrastFilter *contrastFilter;
@property (nonatomic, strong) GPUImageGrayscaleFilter *grayscaleFilter;

@property (nonatomic, strong) GPUImagePicture *sourcePicture;

@property (nonatomic, readonly) UIImage *sourceImage;
@property (nonatomic, strong) UIImage *adjustedImage;

@property (nonatomic, readonly) UIBarButtonItem *printButtonItem;
@property (nonatomic, strong) WYPopoverController *printPopover;

@property (nonatomic) BOOL didSaveImage;

- (IBAction)adjusted;

@end

@implementation DPZAdjusterViewController

@synthesize printButtonItem = _printButtonItem;

- (instancetype)initWithSourceImage:(UIImage *)image {
    if (self = [super initWithNibName:@"DPZAdjusterViewController" bundle:nil]) {
        _sourceImage = image;
        self.title = @"Adjust Image";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.printButtonItem;
    
    self.adjustedImage = [self rotateAndScaleImage:self.sourceImage];
    
    self.imageView = [[GPUImageView alloc] initWithFrame:[self frameForImageView]];
    self.imageView.fillMode = kGPUImageFillModePreserveAspectRatio;
    [self.imageView setBackgroundColorRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    [self.imageViewHolder addSubview:self.imageView];
    
    self.brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    self.contrastFilter = [[GPUImageContrastFilter alloc] init];
    self.grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];

    self.sourcePicture = [[GPUImagePicture alloc] initWithImage:self.adjustedImage smoothlyScaleOutput:YES];
    [self.brightnessFilter forceProcessingAtSize:self.imageView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
    [self.contrastFilter forceProcessingAtSize:self.imageView.sizeInPixels];
    [self.grayscaleFilter forceProcessingAtSize:self.imageView.sizeInPixels];
    
    [self.sourcePicture addTarget:self.brightnessFilter];
    [self.brightnessFilter addTarget:self.contrastFilter];
    [self.contrastFilter addTarget:self.grayscaleFilter];
    [self.grayscaleFilter addTarget:self.imageView];
    
    [self.sourcePicture processImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // We need to adjust the frame for the image view - the correct size for the imageViewHolder isn't set until viewWillAppear
    self.imageView.frame = [self frameForImageView];
}

- (CGRect)frameForImageView
{
    CGRect imageViewHolderFrame = self.imageViewHolder.frame;
    CGSize imageSize = self.adjustedImage.size;
    
    // Scale to fit on screen
    CGFloat scale = MIN(imageViewHolderFrame.size.width/imageSize.width, imageViewHolderFrame.size.height/imageSize.height);
    
    CGFloat w = imageSize.width * scale;
    CGFloat h = imageSize.height * scale;
    CGFloat x = (CGFloat) MAX((imageViewHolderFrame.size.width - w)/2, 0.0);
    CGFloat y = (CGFloat) MAX((imageViewHolderFrame.size.height - h)/2, 0.0);
    CGRect imageViewFrame = CGRectMake(x, y, w, h);
    
    return imageViewFrame;
}

- (IBAction)adjusted
{
    self.didSaveImage = NO;
    [self.brightnessFilter setBrightness:self.brightness.value];
    [self.contrastFilter setContrast:self.contrast.value];
    [self.sourcePicture processImage];
}

- (void)print
{
    DPZAppDelegate *appDelegate = (DPZAppDelegate *)[UIApplication sharedApplication].delegate;
    if (!appDelegate.isCloudReachable)
    {
        [self showUnreachableAlert];
        return;
    }
    
    UIImage *image = [self.grayscaleFilter imageFromCurrentlyProcessedOutput];
    
    UIViewController *printVC = [[DPZPrinterSelectionViewController alloc] initWithCompletionBlock:^(DPZPrinter *printerSelected) {
        [self.printPopover dismissPopoverAnimated:YES options:WYPopoverAnimationOptionFadeWithScale];
        
        if (!printerSelected) {
            return;
        }
        
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Printing…", nil) maskType:SVProgressHUDMaskTypeGradient];
        
        [printerSelected printImage:image context:nil withCompletionBlock:^(BOOL success, NSError *error, id context) {
            if (success) {
                [SVProgressHUD showSuccessWithStatus:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:nil];
                NSLog(@"Print error: %@", error);
            }
        }];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:printVC];
    self.printPopover = [[WYPopoverController alloc] initWithContentViewController:navController];
    self.printPopover.popoverContentSize = CGSizeMake(0.9f*CGRectGetWidth(self.view.bounds), 0.5f*CGRectGetHeight(self.view.bounds));
    [self.printPopover presentPopoverFromBarButtonItem:self.printButtonItem permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES options:WYPopoverAnimationOptionFadeWithScale];
    
    if (!self.didSaveImage) {
        self.didSaveImage = YES;
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
}

/// Rotate image to correct orientation and scale to fit on Little Printer
- (UIImage *)rotateAndScaleImage:(UIImage *)image
{
    CGFloat angle = 0.0;
    UIImageOrientation orientation = self.sourceImage.imageOrientation;
    switch (orientation)
    {
        case UIImageOrientationUp:
            angle = 0.0;
            break;
            
        case UIImageOrientationDown:
            angle = (CGFloat) M_PI;
            break;
            
        case UIImageOrientationLeft:
            angle = (CGFloat) M_PI_2;
            break;
            
        case UIImageOrientationRight:
            angle = (CGFloat) -M_PI_2;
            break;
            
        default:
            angle = 0.0;
            break;
    }

    CGSize originalSize = [self.sourceImage size];
    CGFloat scale = (CGFloat) MIN(LittlePrinterWidth/originalSize.width, 1.0); // Don't scale small images up
    
    CIImage *img = [[CIImage alloc] initWithCGImage:[image CGImage]];;
    CGAffineTransform t = CGAffineTransformMakeScale(scale, scale);
    CIImage *baseImage = [img imageByApplyingTransform:t];
    
    if (angle != 0.0)
    {
        CGAffineTransform rotator = CGAffineTransformMakeRotation(angle);
        baseImage = [baseImage imageByApplyingTransform:rotator];
    }

    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgAdjustedImage = [context createCGImage:baseImage fromRect:baseImage.extent];
    UIImage *adjustedImage = [UIImage imageWithCGImage:cgAdjustedImage];
    CGImageRelease(cgAdjustedImage);
    
    return adjustedImage;
}

#pragma mark - UI Helpers

- (void)showUnreachableAlert
{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Offline", nil)];
}

- (UIBarButtonItem *)printButtonItem
{
    if (!_printButtonItem) {
        _printButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Print", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(print)];
    }
    return _printButtonItem;
}

@end
