#import <UIKit/UIKit.h>
#import "Event.h"
#import "Constants.h"

@class AppController;

//CLASS INTERFACES:

@interface TapViewController : UIViewController <UIAccelerometerDelegate, UITextFieldDelegate>
{
	AppController * appc;
}

@property (nonatomic,retain) AppController * appc;

@end
