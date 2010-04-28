#import "ListButtonViewController.h"


@implementation ListButtonViewController

-(void)viewDidLoad
{	

}

-(void)refreshButtons:(NSMutableArray *)buttons
{		
	//this is a bit stupid, but we do it
	for (UIView * view in self.view.subviews) 
	{
		[view removeFromSuperview];
	}
	
	for(int i = 0; i < [buttons count]; i++) 
	{
		UIButton * btn = (UIButton *) [[TTButtonModel alloc] initWithModel: [buttons objectAtIndex:(NSUInteger) i] style:@"blackForwardButton:"];
		[btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
		[btn sizeToFit];
		[btn setEnabled:YES];
		[self.view addSubview:btn];
	}
}

-(void)toggleButtons
{
	for(int i = 0; i < [[self.view subviews] count]; i++)
	{
		TTButtonModel * btn = [[self.view subviews] objectAtIndex:i];
		
		[[[self.view subviews] objectAtIndex:i] setClickAllowed:!btn.clickAllowed];
	}
}

-(void)buttonClick:(id)sender
{
	TTButtonModel * btn = (TTButtonModel *) sender;
	
	if(btn.clickAllowed)
	{
		NSLog(@">>>> Button pressed \n");
		
		for(int i = 0; i < [btn.model.shortcuts count]; i++) 
		{
			NSLog(@"Shortcut: %@ \n", [btn.model.shortcuts objectAtIndex:i]);
		}
	}
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
    [super dealloc];
}


@end
