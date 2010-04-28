#import "Three20/Three20.h"
#import <UIKit/UIKit.h>
#import "PickerDataSource.h"


@interface EditButtonViewController : UIViewController <UITextFieldDelegate> 
{
	UITextField * firstTextField;
	TTPickerTextField * shortcutField;
	
}
@property (nonatomic, retain) UITextField * firstTextField;
@property (nonatomic, retain) TTPickerTextField * shortcutField;
@end
