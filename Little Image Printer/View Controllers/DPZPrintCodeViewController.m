//
//  DPZPrintCodeViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 09/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZPrintCodeViewController.h"
#import "DPZBergRemoteViewController.h"
#import "DPZAppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface DPZPrintCodeViewController ()  <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation DPZPrintCodeViewController

- (instancetype)init
{
    self = [self initWithNibName:@"DPZPrintCodeViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Print Codes", nil);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"print-code" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)dealloc
{
    self.webView.delegate = nil;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        DPZAppDelegate *appDelegate = (DPZAppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.isCloudReachable) {
            DPZBergRemoteViewController *remoteVC = [[DPZBergRemoteViewController alloc] initWithURL:request.URL title:nil];
            [self.navigationController pushViewController:remoteVC animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Offline", nil)];
        }
        return NO;
    }
    
    return YES;
}

@end
