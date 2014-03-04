//
//  DPZPrintCodeViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 09/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZPrintCodeViewController.h"
#import "DPZBergRemoteViewController.h"

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
        DPZBergRemoteViewController *remoteVC = [[DPZBergRemoteViewController alloc] initWithURL:request.URL];
        [self.navigationController pushViewController:remoteVC animated:YES];
        return NO;
    }
    
    return YES;
}

@end
