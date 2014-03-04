//
//  DPZAboutViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 09/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZAboutViewController.h"

@interface DPZAboutViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation DPZAboutViewController

- (instancetype)init {
    self = [self initWithNibName:@"DPZAboutViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"About";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
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
