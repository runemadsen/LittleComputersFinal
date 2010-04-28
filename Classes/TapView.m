#import "TapView.h"
#import "AppController.h"

@implementation TapViewController

@synthesize appc;

- (void)loadView 
{
	CGRect rect = [[UIScreen mainScreen] bounds];
	UIView * view = [[UIView alloc] initWithFrame:rect];
	[view setBackgroundColor:[UIColor whiteColor]];
	self.view = view;
}

- (void)viewDidLoad 
{
	UIButton * testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[testButton setTitle:@"Send to computer" forState:UIControlStateNormal];
	[testButton addTarget:self action:@selector(buttonPressedAction:) forControlEvents:UIControlEventTouchUpInside];
	testButton.frame = CGRectMake(40, 200, 250, 30);
	
	[self.view addSubview:testButton];
}

- (void)buttonPressedAction:(id)sender
{
	NSLog(@"I hear you");
	
	// Send keyboard key
	//[appc send:EVENT_ASCII with:[string characterAtIndex:0] time:timestamp];
	
	// Send mouse click
	//[appc send:EVENT_MOUSE_DOWN with:MouseEventValue(2, 1) time:0];
	
	// Send one delete
    //[appc send:EVENT_KEY_DOWN with:kKeycodeBackSpace time:timestamp];
	//[appc send:EVENT_KEY_UP with:kKeycodeBackSpace time:timestamp];
}

- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}



- (void)dealloc 
{
	[super dealloc];
}


@end
