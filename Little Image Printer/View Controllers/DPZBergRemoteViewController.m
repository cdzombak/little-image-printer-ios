//
//  DPZBergRemoteViewController.m
//  Little Image Printer
//
//  Created by Chris Dzombak on 3/3/14.
//  Copyright (c) 2014 David Wilkinson. All rights reserved.
//

#import "DPZBergRemoteViewController.h"
#import "DPZAppDelegate.h"

@interface DPZBergRemoteViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, readonly) UIBarButtonItem *refreshButtonItem;

@end

@implementation DPZBergRemoteViewController

@synthesize refreshButtonItem = _refreshButtonItem;

- (instancetype)init
{
    if (self = [super initWithNibName:@"DPZBergRemoteViewController" bundle:nil]) {
        self.title = @"Berg Remote";
    }
    return self;
}

- (void)dealloc
{
    self.webView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://remote.bergcloud.com"]]];
    self.navigationItem.rightBarButtonItem = self.refreshButtonItem;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [(DPZAppDelegate *)[UIApplication sharedApplication].delegate setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [(DPZAppDelegate *)[UIApplication sharedApplication].delegate setNetworkActivityIndicatorVisible:NO];
}

#pragma mark UI Actions

- (void)refreshWebView:(id)sender
{
    [self.webView reload];
}

#pragma mark Lazy Getters

- (UIBarButtonItem *)refreshButtonItem
{
    if (!_refreshButtonItem) {
        _refreshButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshWebView:)];
    }
    return _refreshButtonItem;
}

@end
