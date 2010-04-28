#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "TemplateViewController.h"
#import "TTButtonModel.h"
#import "Event.h"
//#import "AppController.h"
@class AppController;
@class StatesModel;

//@class CustomButton;

@interface ListButtonViewController : UIViewController <UITextFieldDelegate> 
{

}

-(void)refreshButtons:(NSMutableArray *)buttons;
-(void)toggleButtons;

@end
