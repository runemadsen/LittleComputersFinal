#import <UIKit/UIKit.h>
#import <Foundation/NSNetServices.h>

@class BrowserViewController;

@protocol BrowserViewControllerDelegate <NSObject>
@required
// This method will be invoked when the user selects one of the service instances from the list.
// The ref parameter will be the selected (already resolved) instance or nil if the user taps the 'Cancel' button (if shown).
- (void) browserViewController:(BrowserViewController*)bvc didResolveInstance:(NSNetService*)ref;
@end

@interface BrowserViewController : UITableViewController {

@private
	id<BrowserViewControllerDelegate> _delegate;
	NSString* _searchingForServicesString;
	NSString* _ownName;
	NSNetService* _ownEntry;
	BOOL _showDisclosureIndicators;
	NSMutableArray* _services;
	NSNetServiceBrowser* _netServiceBrowser;
	NSNetService* _currentResolve;
	NSTimer* _timer;
	BOOL _needsActivityIndicator;
	BOOL _initialWaitOver;
	UIImage *bonjourIcon;
}

@property (nonatomic, assign) id<BrowserViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString* searchingForServicesString;
@property (nonatomic, copy) NSString* ownName;

- (id)initWithTitle:(NSString *)title showDisclosureIndicators:(BOOL)showDisclosureIndicators showCancelButton:(BOOL)showCancelButton;
- (BOOL)searchForServicesOfType:(NSString *)type inDomain:(NSString *)domain;
- (void)startDemoResolve;

@end
