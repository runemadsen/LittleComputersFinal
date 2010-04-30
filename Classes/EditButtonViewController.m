#import "EditButtonViewController.h"


@implementation EditButtonViewController
@synthesize firstTextField;
@synthesize shortcutView;

- (void) viewDidLoad
{
	UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				   target:self
																				   action:@selector(cancelButton:)];
	
	UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																				 target:self
																				 action:@selector(doneButton:)];
	
	NSArray * items = [NSArray arrayWithObjects: cancelButton, doneButton, nil];	
	
	UIToolbar * tools =[UIToolbarExtend new];
	
	tools.frame = CGRectMake(0, 0, 133, 44.01);
	[tools setItems:items animated:NO];
	
	//[tools setBarStyle:UIBarStyleBlackTranslucent];
	[tools setTranslucent:YES];
	
	// these should change the button colors but they dont
	tools.tintColor = [UIColor colorWithRed:(float) 21.0 / 255.0 green:(float) 24.0 / 255.0 blue:(float) 18.0 / 255.0 alpha:1];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
	
	[cancelButton release];
	[doneButton release];	
	
	
	self.shortcutView = [[ShortcutViewController alloc] init];
	
	[self.view setBackgroundColor:[UIColor colorWithRed:(float) 21.0 / 255.0 green:(float) 24.0 / 255.0 blue:(float) 18.0 / 255.0 alpha:1]];
	
	firstTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 280, 42)];
	firstTextField.background = [UIImage imageNamed:@"textfield.png"];
	firstTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    firstTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	firstTextField.placeholder = @"Button Name";
	firstTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	firstTextField.adjustsFontSizeToFitWidth = NO;
	firstTextField.textColor = [UIColor colorWithWhite:0.56 alpha:1];
	firstTextField.font = [UIFont systemFontOfSize:14];
	[self.view addSubview:firstTextField];
	
	TTButton * btn = [TTButton buttonWithStyle:@"blackForwardButton:" title:@"Shortcut"];
	[btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
	[btn sizeToFit];
	btn.center = CGPointMake(265, 75);
	[self.view addSubview:btn];
	
	[firstTextField becomeFirstResponder];
}

-(void)doneButton:(id)sender
{
	NSNotificationCenter * dc = [NSNotificationCenter defaultCenter];
	[dc postNotification:[NSNotification notificationWithName:@"SaveNewButton" object:self]];
	
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelButton:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	[theTextField resignFirstResponder];
		
    return YES;
}

-(void)buttonClick:(id)sender
{
	[self.navigationController pushViewController:self.shortcutView animated:YES];
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[firstTextField release];
    [super dealloc];
}


@end
