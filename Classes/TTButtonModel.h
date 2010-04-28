#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import "CustomButton.h"

@interface TTButtonModel : TTButton 
{
	CustomButton * model;
	BOOL clickAllowed;
}

@property (retain, nonatomic) CustomButton * model;
@property BOOL clickAllowed;

-(id) initWithModel:(CustomButton *)newModel style:(NSString*)selector;

@end
