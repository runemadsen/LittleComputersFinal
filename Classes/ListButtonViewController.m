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
		CGRect rect = CGRectMake(20, 20, 150, 35);
		CustomButtonView * btn = [[CustomButtonView alloc] initWithFrame:rect model:[buttons objectAtIndex:(NSUInteger) i]];
		[self.view addSubview:btn];
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
