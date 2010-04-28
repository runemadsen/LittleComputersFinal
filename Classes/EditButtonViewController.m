#import "EditButtonViewController.h"


@implementation EditButtonViewController
@synthesize firstTextField;
@synthesize shortcutField;

- (void) viewDidLoad
{
	NSLog(@"View did load");
	
	firstTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, -10, 280, 42)];
	firstTextField.background = [UIImage imageNamed:@"textfield.png"];
	firstTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    firstTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	firstTextField.placeholder = @"Button Name";
	firstTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	firstTextField.adjustsFontSizeToFitWidth = NO;
	firstTextField.textColor = [UIColor colorWithWhite:0.56 alpha:1];
	firstTextField.font = [UIFont systemFontOfSize:14];
	[self.view addSubview:firstTextField];
	
	CGRect frame = TTNavigationFrame();
	frame.origin.y += 45;
	frame.size.height -= 45;
    
    shortcutField = [[[TTPickerTextField alloc] initWithFrame:CGRectMake(20, 40, 280, 42)] autorelease];
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
	
	UIScrollView * scrollView = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
    //scrollView.backgroundColor = TTSTYLEVAR(backgroundColor);
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    scrollView.canCancelContentTouches = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    [firstTextField becomeFirstResponder];
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	[theTextField resignFirstResponder];
		
    return YES;
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
	[shortcutField release];
    [super dealloc];
}


@end
