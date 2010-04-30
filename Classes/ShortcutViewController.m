    //
//  ShortcutViewController.m
//  Final-Templates
//
//  Created by Rune Madsen on 4/29/10.
//  Copyright 2010 New York University. All rights reserved.
//

#import "ShortcutViewController.h"


@implementation ShortcutViewController
@synthesize shortcutField;

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
	[self.view setBackgroundColor:[UIColor colorWithRed:(float) 21.0 / 255.0 green:(float) 24.0 / 255.0 blue:(float) 18.0 / 255.0 alpha:1]];
	
	shortcutField = [[[TTPickerTextField alloc] initWithFrame:CGRectMake(20, 10, 280, 42)] autorelease];
    shortcutField.dataSource = [[[PickerDataSource alloc] init] autorelease];;
    shortcutField.autocorrectionType = UITextAutocorrectionTypeNo;
    shortcutField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    shortcutField.rightViewMode = UITextFieldViewModeAlways;
    shortcutField.delegate = self;
    shortcutField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //[shortcutField sizeToFit];
	shortcutField.font = [UIFont systemFontOfSize:14];
	shortcutField.textColor = [UIColor colorWithWhite:0.56 alpha:1];
	//shortcutField.placeholder = @"Shortcut";
	shortcutField.background = [UIImage imageNamed:@"textfield.png"];
	
	UIScrollView * scrollView = [[[UIScrollView alloc] initWithFrame:TTNavigationFrame()] autorelease];
    //scrollView.backgroundColor = TTSTYLEVAR(backgroundColor);
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    scrollView.canCancelContentTouches = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    //[scrollView addSubview:shortcutField];
	[self.view addSubview:shortcutField];
    
    CGFloat y = 0;
    
    for (UIView *view in scrollView.subviews) 
	{
        view.frame = CGRectMake(0, y, self.view.width, view.height);
        y += view.height;
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.width, y);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
