#import "TemplatesLoader.h"

@implementation TemplatesLoader
@synthesize templates;

/* Init
 ______________________________________________________________ */

-(id)initEmpty
{
	self.templates = [[NSMutableArray alloc] init];
	
	return self;
}

/* Utilities
 ______________________________________________________________ */

-(void)reorderFrom:(NSInteger)oldIndex to:(NSInteger)newIndex
{
	Template * template = [[self.templates objectAtIndex:oldIndex] retain];
	
	[self.templates removeObjectAtIndex:oldIndex];
	[self.templates insertObject:template atIndex:newIndex];
}

-(void)addRow:(Template *)newTemplate
{
	[self.templates addObject:newTemplate];
}

/* Archiving
 ______________________________________________________________ */

- (id) initWithCoder:(NSCoder*)coder
{
	self = [super init];
	
	if(self != nil)
	{
		self.templates = [coder decodeObjectForKey:@"templates"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder
{
	[coder encodeObject:self.templates forKey:@"templates"];
}

/* Dealloc
 ______________________________________________________________ */

- (void)dealloc 
{
    [templates release];
    [super dealloc];
}

@end
