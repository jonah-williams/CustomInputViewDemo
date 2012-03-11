//
//  AppDelegate.m
//  CustomInputViewDemo
//
//  Created by Jonah Williams on 2/14/12.
//  Copyright (c) 2012 Carbon Five. All rights reserved.
//

#import "AppDelegate.h"
#import "MarkdownViewController.h"
#import "MusicScoreViewController.h"
#import "ResponsiveViewController.h"

@implementation AppDelegate

@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    ResponsiveViewController *responsiveViewController = [[ResponsiveViewController alloc] initWithNibName:nil bundle:nil];
    responsiveViewController.title = @"Basic";
    
    MarkdownViewController *markdownViewController = [[MarkdownViewController alloc] initWithNibName:nil bundle:nil];
    markdownViewController.title = @"Markdown";
    
    MusicScoreViewController *musicScoreViewController = [[MusicScoreViewController alloc] initWithNibName:nil bundle:nil];
    musicScoreViewController.title = @"Music Score";
    
    NSArray *tabControllers = [NSArray arrayWithObjects:responsiveViewController, musicScoreViewController, markdownViewController, nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:tabControllers];
    [self.window setRootViewController:tabBarController];
    tabBarController = nil;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
