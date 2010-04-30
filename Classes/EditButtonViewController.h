#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "ShortcutViewController.h"
#import "UIToolbarExtend.h"

@interface EditButtonViewController : UIViewController <UITextFieldDelegate> 
{
	UITextField * firstTextField;
	ShortcutViewController * shortcutView;
	
}
@property (nonatomic, retain) UITextField * firstTextField;
@property (nonatomic, retain) ShortcutViewController * shortcutView;

@end
