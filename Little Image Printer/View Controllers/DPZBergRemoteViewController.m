//
//  DPZBergRemoteViewController.m
//  Little Image Printer
//
//  Created by Chris Dzombak on 3/3/14.
//  Copyright (c) 2014 David Wilkinson. All rights reserved.
//

#import "DPZBergRemoteViewController.h"
#import "DPZAppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface DPZBergRemoteViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, readonly) UIBarButtonItem *refreshButtonItem;

@property (nonatomic, readonly) NSURL *url;

@end

@implementation DPZBergRemoteViewController

@synthesize refreshButtonItem = _refreshButtonItem;

- (instancetype)initWithURL:(NSURL *)urlOrNil title:(NSString *)titleOrNil
{
    if (self = [super initWithNibName:@"DPZBergRemoteViewController" bundle:nil]) {
        self.title = titleOrNil ?: NSLocalizedString(@"Berg Remote", nil);
        _url = urlOrNil ?: [NSURL URLWithString:@"http://remote.bergcloud.com"];
    }
    return self;
}

- (void)dealloc
{
    self.webView.delegate = nil;
    [(DPZAppDelegate *)[UIApplication sharedApplication].delegate setNetworkActivityIndicatorVisible:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [SVProgressHUD show];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    self.navigationItem.rightBarButtonItem = self.refreshButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [(DPZAppDelegate *)[UIApplication sharedApplication].delegate setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    [(DPZAppDelegate *)[UIApplication sharedApplication].delegate setNetworkActivityIndicatorVisible:NO];
}

#pragma mark UI Actions

- (void)refreshWebView:(id)sender
{
    [SVProgressHUD show];
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
