#import <Foundation/Foundation.h>


@interface Template : NSObject <NSCoding> 
{	
	NSString * name;
	NSMutableArray * buttons;
}

@property(nonatomic, copy) NSString * name;
@property(nonatomic, retain) NSMutableArray * buttons;

-(id)initWithName:(NSString*)n;

@end
