#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "TemplateViewController.h"
#import "TTButtonModel.h"


//@class CustomButton;

@interface ListButtonViewController : UIViewController <UITextFieldDelegate> 
{

}

-(void)refreshButtons:(NSMutableArray *)buttons;
-(void)toggleButtons;

@end
