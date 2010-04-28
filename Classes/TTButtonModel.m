#import "TTButtonModel.h"

@implementation TTButtonModel
@synthesize model;
@synthesize clickAllowed;

-(id) initWithModel:(CustomButton *)newModel style:(NSString*)selector
{
	self = [super init];
	
	if(self != nil)
	{
		self.model = newModel;
		
		[self setTitle:self.model.name forState:UIControlStateNormal];
		[self setStylesWithSelector:selector];
		[self sizeToFit];
		[self setEnabled:YES];
		self.center = self.model.location;
	
		self.clickAllowed = YES;
		
		/*printf("Center X: %f \n", self.center.x);
		printf("Center Y: %f \n", self.center.y);
		printf("Frame X: %f \n", self.frame.origin.x);
		printf("Frame Y: %f \n", self.frame.origin.y);*/
	}
	
	return self;
}


/* Events
 ______________________________________________________________ */

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{	
	if(!self.clickAllowed)
	{
		UITouch * touch = [touches anyObject];
		CGPoint location = [touch locationInView:self.superview];
		self.center = location;
		
		// update the model
		self.model.location = location;
		
		/*printf("MOVE Center X: %f \n", self.center.x);
		printf("MOVE Center Y: %f \n", self.center.y);
		printf("Frame X: %f \n", self.frame.origin.x);
		printf("Frame Y: %f \n", self.frame.origin.y);*/
	}
}

@end
