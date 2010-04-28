#import "CustomButtonView.h"

@implementation CustomButtonView
@synthesize button;
@synthesize model;

- (id)initWithFrame:(CGRect)frame model:(CustomButton *)newModel
{
    if (self = [super initWithFrame:frame]) 
	{
		self.model = newModel;
		self.frame = frame;
		self.bounds = frame;
		self.center = self.model.location;
		
		UIButton * btn = (UIButton *) [TTButton buttonWithStyle:@"blackForwardButton:" title:self.model.name];
		button.titleLabel.font = [UIFont systemFontOfSize:26];
		
		btn.frame = frame;
		[btn sizeToFit];
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
		[btn setEnabled:YES];
		[self setButton:btn];
        [self addSubview:button];
    }
	
    return self;
}

/* Events
 ______________________________________________________________ */

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{	
	UITouch * touch = [touches anyObject];
	CGPoint location = [touch locationInView:self.superview];
	self.center = location;
	
	// update the model
	self.model.location = location;
}

-(IBAction)buttonClick:(id)sender
{
	NSLog(@">>>> Button pressed \n");
	
	for(int i = 0; i < [self.model.shortcuts count]; i++) 
	{
		NSLog(@"Shortcut: %@ \n", [self.model.shortcuts objectAtIndex:i]);
	}
}

@end
