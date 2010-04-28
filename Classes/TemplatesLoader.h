#import <Foundation/Foundation.h>
#import "Template.h"
#import "LCFileHelpers.h"
#import <sqlite3.h>

@interface TemplatesLoader : NSObject <NSCoding> 
{
	NSMutableArray * templates;
}

@property (nonatomic, retain) NSMutableArray * templates;

- (id) initEmpty;
- (void) reorderFrom:(NSInteger)oldIndex to:(NSInteger)newIndex;
- (void) addRow:(Template *)newTemplate;

@end
