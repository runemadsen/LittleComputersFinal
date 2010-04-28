//
//  AddTemplateViewController.m
//  Final-Templates
//
//  Created by Rune Madsen on 4/8/10.
//  Copyright 2010 New York University. All rights reserved.
//

#import "AddTemplateViewController.h"


@implementation AddTemplateViewController
@synthesize templateName;

- (IBAction) save:(id)sender
{		
	NSNotificationCenter * dc = [NSNotificationCenter defaultCenter];
	[dc postNotification:[NSNotification notificationWithName:@"SaveNewTemplate" object:self]];
	
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
