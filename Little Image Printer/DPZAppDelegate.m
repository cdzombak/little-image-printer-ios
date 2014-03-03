//
//  DPZAppDelegate.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZAppDelegate.h"

#import "DPZViewController.h"
#import "Reachability.h"

@interface DPZAppDelegate ()

@property (nonatomic, readonly) Reachability *reachability;

@end

@implementation DPZAppDelegate

@synthesize reachability = _reachability;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSAssert([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone, @"Only iPhone is supported.");
    
    DPZViewController *vc = [[DPZViewController alloc] initWithNibName:@"DPZViewController_iPhone" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self setupStyles];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - App Setup

- (void)setupStyles
{
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.824 green:0.337 blue:0.071 alpha:1]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.824 green:0.337 blue:0.071 alpha:1]];
}

#pragma mark - Reachability

- (Reachability *)reachability {
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
