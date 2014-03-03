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

@property (nonatomic, strong) Reachability *reachability;

@end

@implementation DPZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.reachability = [Reachability reachabilityWithHostname:@"remote.bergcloud.com"];    

    NSAssert([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone, @"Only iPhone is supported.");
    
    DPZViewController *vc = [[DPZViewController alloc] initWithNibName:@"DPZViewController_iPhone" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)isCloudReachable
{
    return self.reachability.isReachable;
}

@end
