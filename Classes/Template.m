//
//  Template.m
//  Final-Templates
//
//  Created by Rune Madsen on 4/7/10.
//  Copyright 2010 New York University. All rights reserved.
//

#import "Template.h"


@implementation Template
@synthesize name;
@synthesize buttons;

/* Init
 ______________________________________________________________ */

-(id)initWithName:(NSString*)n 
{
	self.name = n;
	self.buttons = [[NSMutableArray alloc] init];
	
	return self;
}

/* Archiving
 ______________________________________________________________ */

- (id) initWithCoder:(NSCoder*)coder
{
	self = [super init];
	
	if(self != nil)
	{
		self.name = [coder decodeObjectForKey:@"name"];
		self.buttons = [coder decodeObjectForKey:@"buttons"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder
{
	[coder encodeObject:self.name forKey:@"name"];
	[coder encodeObject:self.buttons forKey:@"buttons"];
}

/* Dealloc
 ______________________________________________________________ */

- (void)dealloc 
{
    [name release];
	[buttons release];
    [super dealloc];
}

@end
