//
//  Final_TemplatesAppDelegate.m
//  Final-Templates
//
//  Created by Rune Madsen on 4/7/10.
//  Copyright New York University 2010. All rights reserved.
//

#import "Final_TemplatesAppDelegate.h"
#import "RootViewController.h"
#import "ButtonStylesheet.h"

@implementation Final_TemplatesAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// style the navigationbar
	navigationController = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] initWithStyle:UITableViewStylePlain]];
	navigationController.navigationBar.tintColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	
	[TTStyleSheet setGlobalStyleSheet:[[[ButtonStyleSheet alloc] init] autorelease]];
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application 
{
	NSNotificationCenter * dc = [NSNotificationCenter defaultCenter];
	[dc postNotification:[NSNotification notificationWithName:@"ApplicationTerminate" object:self]];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc 
{
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

