#import "AppController.h"
#import "TapView.h"
#import "Constants.h"

#include <sys/time.h>

//INTERFACES:

@interface AppController ()
- (void) setup;
- (void) presentPicker:(NSString*)name;
@end

//CLASS IMPLEMENTATIONS:

@implementation AppController
@synthesize templatesViewController;

- (void) _showAlert:(NSString*)title
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:@"Check your networking configuration." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	[application setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
	
	//Create a full-screen window
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[_window setBackgroundColor:[UIColor darkGrayColor]];
	
	//Create a picker view
	pickerViewController = [[PickerViewController alloc] init];
	navigationController = [[UINavigationController alloc] initWithRootViewController:pickerViewController];
	navigationController.navigationBar.tintColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	
	[TTStyleSheet setGlobalStyleSheet:[[[ButtonStyleSheet alloc] init] autorelease]];
	
	// Create template screen
	templatesViewController = [[TemplatesViewController alloc] init];
	//[tapViewController setAppc:self];

	[_window addSubview:navigationController.view];
	[_window makeKeyAndVisible];
	
	//Create and advertise a new game and discover other availble games
	[self setup];
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
	//[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSNotificationCenter * dc = [NSNotificationCenter defaultCenter];
	[dc postNotification:[NSNotification notificationWithName:@"ApplicationTerminate" object:self]];
}

- (void) dealloc
{
	//[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
	
	[self closeStreams];
	[_server release];
	
	[templatesViewController release];
	[setupViewController release];
	[navigationController release];
	[pickerViewController release];

	[_window release];
	
	[super dealloc];
}

- (void) setup 
{
	[self closeStreams];
	[_server release];
	
	_server = [TCPServer new];
	[_server setDelegate:self];
	NSError* error;
	if(_server == nil || ![_server start:&error]) 
	{
		NSLog(@"Failed creating server: %@", error);
		[self _showAlert:@"Failed creating server"];
		return;
	}
	
	//Start advertising to clients, passing nil for the name to tell Bonjour to pick use default name
	if(![_server enableBonjourWithDomain:@"local" applicationProtocol:[TCPServer bonjourTypeFromIdentifier:kBonjourIdentifier] name:nil]) {
		[self _showAlert:@"Failed advertising server"];
		return;
	}
	
	[self presentPicker:nil];
}

- (void) showTapView 
{	
	[navigationController pushViewController:templatesViewController animated:YES];
}

// Make sure to let the user know what name is being used for Bonjour advertisement.
// This way, other players can browse for and connect to this game.
// Note that this may be called while the alert is already being displayed, as
// Bonjour may detect a name conflict and rename dynamically.
- (void) presentPicker:(NSString*)name 
{
	[(Picker *)[pickerViewController view] setGameName:name];
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
	[navigationController popToRootViewControllerAnimated:YES];
}

// If we display an error or an alert that the remote disconnected, handle dismissal and return to setup
- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self setup];
}

- (void)send:(uint32_t)type with:(int32_t)value time:(NSTimeInterval)timestamp 
{
	uint32_t tv_sec = (uint32_t)timestamp;
	MouseEvent event = {htonl(type), htonl(value), htonl(tv_sec), htonl((long)((timestamp-tv_sec)*1.0E9))};

	if (_outStream && [_outStream hasSpaceAvailable])
		if([_outStream write:(uint8_t *)&event maxLength:sizeof(MouseEvent)] == -1)
			[self _showAlert:@"Failed sending data to peer"];
}

- (void) openStreams
{
	_inStream.delegate = self;
	[_inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_inStream open];
	_outStream.delegate = self;
	[_outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outStream open];
}

- (void) closeStreams {
	[_inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_inStream close];
	[_inStream release];
	_inStream = nil;
	_inReady = NO;
	
	[_outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outStream close];
	[_outStream release];
	_outStream = nil;
	_outReady = NO;
}

- (void) browserViewController:(BrowserViewController *)bvc didResolveInstance:(NSNetService*)netService
{
	if (!netService) {
		[self setup];
		return;
	}

	if (![netService getInputStream:&_inStream outputStream:&_outStream]) {
		[self _showAlert:@"Failed connecting to server"];
		return;
	}

	[self openStreams];
}

- (void)setInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
	_inStream = inputStream;
	[_inStream retain];
	_outStream = outputStream;
	[_outStream retain];
	
	[self openStreams];
}

@end

@implementation AppController (NSStreamDelegate)

- (void) stream:(NSStream*)stream handleEvent:(NSStreamEvent)eventCode
{
	UIAlertView* alertView;
	switch(eventCode) {
		case NSStreamEventOpenCompleted:
		{
			[_server release];
			_server = nil;

			if (stream == _inStream)
				_inReady = YES;
			else
				_outReady = YES;
			
			if (_inReady && _outReady) 
			{
				[self showTapView];
				
				alertView = [[UIAlertView alloc] initWithTitle:@"Connected!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
				[alertView show];
				[alertView release];
			}
			break;
		}
		case NSStreamEventHasBytesAvailable:
		{
			if (stream == _inStream) {
				uint8_t b;
				unsigned int len = 0;
				len = [_inStream read:&b maxLength:sizeof(uint8_t)];
				if(!len) {
					if ([stream streamStatus] != NSStreamStatusAtEnd)
						[self _showAlert:@"Failed reading data from peer"];
				}
			}
			break;
		}
		case NSStreamEventEndEncountered:
		{
			UIAlertView*			alertView;
			
			alertView = [[UIAlertView alloc] initWithTitle:@"Peer Disconnected!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
			[alertView show];
			[alertView release];

			break;
		}
		case NSStreamEventErrorOccurred:
		{
			NSError *theError = [stream streamError];
			UIAlertView *alertView;
			NSString *message = @"";
			if ([[theError domain] isEqualToString:NSPOSIXErrorDomain]) {
				switch ([theError code]) {
					case EAFNOSUPPORT:
						message = @"\nAdvice:\nPlease change the settings of your Firewall on your Mac to allow connections for the RemotePad Server.";
						break;
					case ETIMEDOUT:
						message = @"\nAdvice:\nPlease change the settings of your Windows Firewall on your PC to allow connections for the RemotePad Server.";
						break;
				}
			}
			[self closeStreams];
			alertView = [[UIAlertView alloc] initWithTitle:@"Error from stream!" message:[NSString stringWithFormat:@"System Message:\n%@%@", [theError localizedDescription], message] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
			[alertView show];
			[alertView release];
			if (!_server)
				[self setup];
			break;
		}
	}
}

@end

@implementation AppController (TCPServerDelegate)

- (void) serverDidEnableBonjour:(TCPServer*)server withName:(NSString*)string
{
	NSLog(@"%s", _cmd);
	[self presentPicker:string];
}

- (void)didAcceptConnectionForServer:(TCPServer*)server inputStream:(NSInputStream *)istr outputStream:(NSOutputStream *)ostr
{
	if (_inStream || _outStream || server != _server)
		return;
	
	[_server release];
	_server = nil;
	
	_inStream = istr;
	[_inStream retain];
	_outStream = ostr;
	[_outStream retain];
	
	[self openStreams];
}

@end
