//
//  DPZAppDelegate.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZAppDelegate.h"

#import "Reachability.h"
#import "DPZRootViewController.h"
#import "DPZColor.h"
#import <WYPopoverController/WYPopoverController.h>

@interface DPZAppDelegate ()

@property (nonatomic, readonly) Reachability *reachability;
@property (atomic) NSInteger networkRequestCount;

@end

@implementation DPZAppDelegate

@synthesize reachability = _reachability;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSAssert([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone, @"Only iPhone is supported.");
    
    [self setupStyles];
    
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:[[DPZRootViewController alloc] init]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible
{
    if (setVisible) {
        self.networkRequestCount++;
    } else {
        self.networkRequestCount--;
    }
    
    self.networkRequestCount = MAX(0, self.networkRequestCount);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(self.networkRequestCount > 0)];
}

#pragma mark - App Setup

- (void)setupStyles
{
    [[UIView appearance] setTintColor:[DPZColor dpz_tintColor]];
}

#pragma mark - Reachability

- (Reachability *)reachability
{
    if (!_reachability) {
        _reachability = [Reachability reachabilityWithHostname:@"remote.bergcloud.com"];
    }
    return _reachability;
}

- (BOOL)isCloudReachable
{
    return self.reachability.isReachable;
}

@end
