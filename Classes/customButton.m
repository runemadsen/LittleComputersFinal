#import "CustomButton.h"


@implementation CustomButton

@synthesize name;
@synthesize shortcut;
@synthesize shortcuts;
@synthesize location;

/* Archiving
 ______________________________________________________________ */

- (id) initWithCoder:(NSCoder*)coder
{
	self = [super init];
	
	if(self != nil)
	{
		self.name = [coder decodeObjectForKey:@"name"];
		self.shortcut = [coder decodeObjectForKey:@"shortcut"];
		self.shortcuts = [coder decodeObjectForKey:@"shortcuts"];
		//self.location = [coder decodePointForKey:@"location"];
		
		float x = [coder decodeFloatForKey:@"location.x"];
		float y = [coder decodeFloatForKey:@"location.y"];
		
		self.location = CGPointMake(x, y);
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder
{
	[coder encodeObject:self.name forKey:@"name"];
	[coder encodeObject:self.shortcut forKey:@"shortcut"];
	[coder encodeObject:self.shortcuts forKey:@"shortcuts"];
	//[coder encodePoint:self.location forKey:@"location"];
	
	[coder encodeFloat:self.location.x forKey:@"location.x"];
	[coder encodeFloat:self.location.y forKey:@"location.y"];
}

/* Dealloc
 ______________________________________________________________ */

- (void)dealloc 
{
    [name release];
	[shortcut release];
	[shortcuts release];
    [super dealloc];
}

@end






