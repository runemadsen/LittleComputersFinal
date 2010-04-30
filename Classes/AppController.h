//#import "TapView.h"  see EOF
#import "BrowserViewController.h"
#import "PickerViewController.h"
#import "Picker.h"
#import "TCPServer.h"
#import "Event.h"
#import "TemplatesViewController.h"
#import "ButtonStylesheet.h"

//CLASS INTERFACES:

@interface AppController : NSObject <UIApplicationDelegate, UIActionSheetDelegate, BrowserViewControllerDelegate, TCPServerDelegate>
{
	UIWindow * _window;
	TCPServer * _server;
	
	NSInputStream * _inStream;
	NSOutputStream * _outStream;
	
	BOOL _inReady;
	BOOL _outReady;
	
	TemplatesViewController	* templatesViewController;
	UINavigationController * navigationController;
	PickerViewController * pickerViewController;
}

- (void) send:(uint32_t)type with:(int32_t)value time:(NSTimeInterval)timestamp;
- (void)setInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream;
- (void) setup;
- (void) closeStreams;

@property (readonly) TemplatesViewController * templatesViewController;

@end
