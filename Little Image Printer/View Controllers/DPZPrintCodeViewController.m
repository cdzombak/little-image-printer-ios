//
//  DPZPrintCodeViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 09/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZPrintCodeViewController.h"

@implementation DPZPrintCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Print Codes";
    
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
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}

@end
