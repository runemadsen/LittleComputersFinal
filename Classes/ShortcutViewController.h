#import "PickerDataSource.h"
#import "Three20/Three20.h"
#import <UIKit/UIKit.h>

@interface ShortcutViewController : UIViewController <UITextFieldDelegate> 
{
	TTPickerTextField * shortcutField;
}

@property (nonatomic, retain) TTPickerTextField * shortcutField;

@end
