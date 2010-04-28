//#import "TapView.h"  see EOF
#import "BrowserViewController.h"
#import "PickerViewController.h"
#import "Picker.h"
#import "TCPServer.h"
#import "Event.h"

@class TapViewController;
@class SetupViewController;

//CLASS INTERFACES:

@interface AppController : NSObject <UIApplicationDelegate, UIActionSheetDelegate, BrowserViewControllerDelegate, TCPServerDelegate>
{
	UIWindow * _window;
	TCPServer * _server;
	NSInputStream * _inStream;
	NSOutputStream * _outStream;
	BOOL _inReady;
	BOOL _outReady;
	TapViewController	* tapViewController;
	SetupViewController * setupViewController;
	UINavigationController * navigationController;
	PickerViewController * pickerViewController;
}

- (void) send:(uint32_t)type with:(int32_t)value time:(NSTimeInterval)timestamp;
- (void)setInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream;
- (void) setup;
- (void) closeStreams;

@property (readonly) TapViewController *tapViewController;

@end
