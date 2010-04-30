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
	
	AppController * appc = (AppController *)[[UIApplication sharedApplication] delegate];
	
	if(btn.clickAllowed)
	{
		NSLog(@">>>> Button pressed \n");
		
		NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
		
		[appc send:EVENT_MOUSE_DOWN with:MouseEventValue(2, 1) time:timestamp];
		
		for(int i = 0; i < [btn.model.shortcuts count]; i++) 
		{
			NSString * str = [btn.model.shortcuts objectAtIndex:i];
			
			if([str length] == 1)
			{
				[appc send:EVENT_ASCII with:str time:timestamp];
			}
			else if([str isEqualToString:@"Shift"])	
			{
				[appc send:EVENT_KEY_DOWN with:kKeycodeShift time:timestamp];
				[appc send:EVENT_KEY_UP with:kKeycodeShift time:timestamp];
			}
			else if([str isEqualToString:@"Option"])
			{
				[appc send:EVENT_KEY_DOWN with:kKeycodeOption time:timestamp];
				[appc send:EVENT_KEY_UP with:kKeycodeOption time:timestamp];
			}
			else if([str isEqualToString:@"Right Arrow"])
			{
				[appc send:EVENT_KEY_DOWN with:kKeycodeRight time:timestamp];
				[appc send:EVENT_KEY_UP with:kKeycodeRight time:timestamp];
			}
			else if([str isEqualToString:@"Left Arrow"])
			{
				[appc send:EVENT_KEY_DOWN with:kKeycodeLeft time:timestamp];
				[appc send:EVENT_KEY_UP with:kKeycodeLeft time:timestamp];
			}
			else if([str isEqualToString:@"Up Arrow"])
			{
				[appc send:EVENT_KEY_DOWN with:kKeycodeUp time:timestamp];
				[appc send:EVENT_KEY_UP with:kKeycodeUp time:timestamp];
			}
			else if([str isEqualToString:@"Down Arrow"])
			{
				[appc send:EVENT_KEY_DOWN with:kKeycodeDown time:timestamp];
				[appc send:EVENT_KEY_UP with:kKeycodeDown time:timestamp];
			}
			else if([str isEqualToString:@"Return"])
			{
				[appc send:EVENT_KEY_DOWN with:kKeycodeReturn time:timestamp];
				[appc send:EVENT_KEY_UP with:kKeycodeReturn time:timestamp];
			}
			else if([str isEqualToString:@"Delete"])	
			{
				[appc send:EVENT_KEY_DOWN with:kKeycodeBackSpace time:timestamp];
				[appc send:EVENT_KEY_UP with:kKeycodeBackSpace time:timestamp];
			}
			else if([str isEqualToString:@"Mouse Left"])	
			{
				[appc send:EVENT_MOUSE_DOWN with:MouseEventValue(1, 1) time:timestamp];
				[appc send:EVENT_MOUSE_UP with:MouseEventValue(1, 1) time:timestamp];
			}
			else if([str isEqualToString:@"Mouse Middle"])	
			{
				[appc send:EVENT_MOUSE_DOWN with:MouseEventValue(2, 1) time:timestamp];
				[appc send:EVENT_MOUSE_UP with:MouseEventValue(2, 1) time:timestamp];
			}
			else if([str isEqualToString:@"Mouse Right"])	
			{
				[appc send:EVENT_MOUSE_DOWN with:MouseEventValue(3, 1) time:timestamp];
				[appc send:EVENT_MOUSE_UP with:MouseEventValue(3, 1) time:timestamp];
			}
			
			[str release];

			
			// Send keyboard key
			//[appc send:EVENT_ASCII with:[btn.model.shortcuts objectAtIndex:i] time:timestamp];
			
			// Send mouse click
			//[appc send:EVENT_MOUSE_DOWN with:MouseEventValue(2, 1) time:timestamp];
			
			// Send one delete
			//[appc send:EVENT_KEY_DOWN with:kKeycodeBackSpace time:timestamp];
			//[appc send:EVENT_KEY_UP with:kKeycodeBackSpace time:timestamp];
			
			NSLog(@"Send message: %@ \n", [btn.model.shortcuts objectAtIndex:i]);
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
