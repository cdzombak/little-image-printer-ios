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

@interface DPZAppDelegate ()

@property (nonatomic, readonly) Reachability *reachability;

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

#pragma mark - App Setup

- (void)setupStyles
{
    [[UIView appearance] setTintColor:[UIColor colorWithRed:0.824f green:0.337f blue:0.071f alpha:1.0]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithWhite:0.0 alpha:0.9f]];
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
