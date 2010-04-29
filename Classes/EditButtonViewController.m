#import "EditButtonViewController.h"


@implementation EditButtonViewController
@synthesize firstTextField;
@synthesize shortcutView;

- (void) viewDidLoad
{
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
