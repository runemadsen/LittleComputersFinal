#import "BrowserViewController.h"

#define kProgressIndicatorSize 20.0

// A category on NSNetService that's used to sort NSNetService objects by their name.
@interface NSNetService (BrowserViewControllerAdditions)
- (NSComparisonResult) localizedCaseInsensitiveCompareByName:(NSNetService*)aService;
@end

@implementation NSNetService (BrowserViewControllerAdditions)
- (NSComparisonResult) localizedCaseInsensitiveCompareByName:(NSNetService*)aService {
	return [[self name] localizedCaseInsensitiveCompare:[aService name]];
}
@end


@interface BrowserViewController()
@property (nonatomic, retain, readwrite) NSNetService* ownEntry;
@property (nonatomic, assign, readwrite) BOOL showDisclosureIndicators;
@property (nonatomic, retain, readwrite) NSMutableArray* services;
@property (nonatomic, retain, readwrite) NSNetServiceBrowser* netServiceBrowser;
@property (nonatomic, retain, readwrite) NSNetService* currentResolve;
@property (nonatomic, retain, readwrite) NSTimer* timer;
@property (nonatomic, assign, readwrite) BOOL needsActivityIndicator;
@property (nonatomic, assign, readwrite) BOOL initialWaitOver;

- (void)stopCurrentResolve;
- (void)initialWaitOver:(NSTimer*)timer;
@end

@implementation BrowserViewController

@synthesize delegate = _delegate;
@synthesize ownEntry = _ownEntry;
@synthesize showDisclosureIndicators = _showDisclosureIndicators;
@synthesize currentResolve = _currentResolve;
@synthesize netServiceBrowser = _netServiceBrowser;
@synthesize services = _services;
@synthesize needsActivityIndicator = _needsActivityIndicator;
@dynamic timer;
@synthesize initialWaitOver = _initialWaitOver;


- (id)initWithTitle:(NSString*)title showDisclosureIndicators:(BOOL)show showCancelButton:(BOOL)showCancelButton {
	
	if ((self = [super initWithStyle:UITableViewStylePlain])) {
		self.title = title;
		_services = [[NSMutableArray alloc] init];
		self.showDisclosureIndicators = show;

		if (showCancelButton) {
			// add Cancel button as the nav bar's custom right view
			UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
										  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
			self.navigationItem.rightBarButtonItem = addButton;
			[addButton release];
		}

		self.searchingForServicesString = @"Searching for servers...";
		bonjourIcon = [[UIImage imageNamed:@"Bonjour.png"] retain];
		
		// Style background
		[self.tableView setBackgroundColor:[UIColor colorWithRed:(float) 21.0 / 255.0 green:(float) 24.0 / 255.0 blue:(float) 18.0 / 255.0 alpha:1]];
		self.tableView.separatorColor = [UIColor colorWithWhite:.12 alpha:1];

		// Make sure we have a chance to discover devices before showing the user that nothing was found (yet)
		[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(initialWaitOver:) userInfo:nil repeats:NO];
	}

	return self;
}

- (NSString *)searchingForServicesString {
	return _searchingForServicesString;
}

// Holds the string that's displayed in the table view during service discovery.
- (void)setSearchingForServicesString:(NSString *)searchingForServicesString {
	if (_searchingForServicesString != searchingForServicesString) {
		[_searchingForServicesString release];
		_searchingForServicesString = [searchingForServicesString copy];

        // If there are no services, reload the table to ensure that searchingForServicesString appears.
		if ([self.services count] == 0) {
			[self.tableView reloadData];
		}
	}
}

- (NSString *)ownName {
	return _ownName;
}

// Holds the string that's displayed in the table view during service discovery.
- (void)setOwnName:(NSString *)name {
	if (_ownName != name) {
		_ownName = [name copy];
		
		if (self.ownEntry)
			[self.services addObject:self.ownEntry];
		
		NSNetService* service;
		
		for (service in self.services) {
			if ([service.name isEqual:name]) {
				self.ownEntry = service;
				[_services removeObject:service];
				break;
			}
		}
		
		[self.tableView reloadData];
	}
}

// Creates an NSNetServiceBrowser that searches for services of a particular type in a particular domain.
// If a service is currently being resolved, stop resolving it and stop the service browser from
// discovering other services.
- (BOOL)searchForServicesOfType:(NSString *)type inDomain:(NSString *)domain {
	
	[self stopCurrentResolve];
	[self.netServiceBrowser stop];
	[self.services removeAllObjects];

	NSNetServiceBrowser *aNetServiceBrowser = [[NSNetServiceBrowser alloc] init];
	if(!aNetServiceBrowser) {
        // The NSNetServiceBrowser couldn't be allocated and initialized.
		return NO;
	}

	aNetServiceBrowser.delegate = self;
	self.netServiceBrowser = aNetServiceBrowser;
	[aNetServiceBrowser release];
	[self.netServiceBrowser searchForServicesOfType:type inDomain:domain];

	[self.tableView reloadData];
	return YES;
}


- (NSTimer *)timer {
	return _timer;
}

// When this is called, invalidate the existing timer before releasing it.
- (void)setTimer:(NSTimer *)newTimer {
	[_timer invalidate];
	[newTimer retain];
	[_timer release];
	_timer = newTimer;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// If there are no services and searchingForServicesString is set, show one row to tell the user.
	NSUInteger count = [self.services count];
	if (count == 0 && self.searchingForServicesString && self.initialWaitOver)
		return 1;

	return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *tableCellIdentifier = @"UITableViewCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:tableCellIdentifier] autorelease];
	}
	
	cell.image = bonjourIcon;
	
	NSUInteger count = [self.services count];
	if (count == 0 && self.searchingForServicesString) {
        // If there are no services and searchingForServicesString is set, show one row explaining that to the user.
        cell.text = self.searchingForServicesString;
		cell.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
		cell.accessoryType = UITableViewCellAccessoryNone;
		return cell;
	}
	
	// Set up the text for the cell
	NSNetService* service = [self.services objectAtIndex:indexPath.row];
	cell.text = [service name];
	[cell setBackgroundColor:[UIColor colorWithRed:(float) 21.0 / 255.0 green:(float) 24.0 / 255.0 blue:(float) 18.0 / 255.0 alpha:1]];
	cell.textLabel.textColor = [UIColor colorWithWhite:.85 alpha:1];
	//cell.textColor = [UIColor blackColor];
	cell.accessoryType = self.showDisclosureIndicators ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	
	// Note that the underlying array could have changed, and we want to show the activity indicator on the correct cell
	if (self.needsActivityIndicator && self.currentResolve == service) {
		if (!cell.accessoryView) {
			CGRect frame = CGRectMake(0.0, 0.0, kProgressIndicatorSize, kProgressIndicatorSize);
			UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithFrame:frame];
			[spinner startAnimating];
			spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
			[spinner sizeToFit];
			spinner.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
										UIViewAutoresizingFlexibleRightMargin |
										UIViewAutoresizingFlexibleTopMargin |
										UIViewAutoresizingFlexibleBottomMargin);
			cell.accessoryView = spinner;
			[spinner release];
		}
	} else if (cell.accessoryView) {
		cell.accessoryView = nil;
	}
	
	return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Ignore the selection if there are no services.
	if ([self.services count] == 0)
		return nil;

	return indexPath;
}


- (void)stopCurrentResolve {

	self.needsActivityIndicator = NO;
	self.timer = nil;

	[self.currentResolve stop];
	self.currentResolve = nil;
}


- (void)startDemoResolve {
	if (self.ownEntry == nil)
		return;
	[self stopCurrentResolve];
	self.currentResolve = self.ownEntry;
	[self.currentResolve setDelegate:self];
	[self.currentResolve resolveWithTimeout:0.0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// If another resolve was running, stop it first
	
	[self stopCurrentResolve];
	self.currentResolve = [self.services objectAtIndex:indexPath.row];

	[self.currentResolve setDelegate:self];
	// Attempt to resolve the service. A value of 0.0 sets an unlimited time to resolve it. The user can
	// choose to cancel the resolve by selecting another service in the table view.
	[self.currentResolve resolveWithTimeout:0.0];
	
	// Make sure we give the user some feedback that the resolve is happening.
	// We will be called back asynchronously, so we don't want the user to think
	// we're just stuck.
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showWaiting:) userInfo:self.currentResolve repeats:NO];
	[self.tableView reloadData];
}

// If necessary, sets up state to show an activity indicator to let the user know that a resolve is occuring.
- (void)showWaiting:(NSTimer*)timer {
	
	if (timer == self.timer) {
		[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
		NSNetService* service = (NSNetService*)[self.timer userInfo];
		if (self.currentResolve == service) {
			self.needsActivityIndicator = YES;
			[self.tableView reloadData];
		}
	}
}


- (void)initialWaitOver:(NSTimer*)timer {
	self.initialWaitOver= YES;
	if (![self.services count])
		[self.tableView reloadData];
}


- (void)sortAndUpdateUI {
	// Sort the services by name.
	[self.services sortUsingSelector:@selector(localizedCaseInsensitiveCompareByName:)];
	[self.tableView reloadData];
}


- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didRemoveService:(NSNetService*)service moreComing:(BOOL)moreComing {
	// If a service went away, stop resolving it if it's currently being resolve,
	// remove it from the list and update the table view if no more events are queued.
	
	if (self.currentResolve && [service isEqual:self.currentResolve]) {
		[self stopCurrentResolve];
	}
	[self.services removeObject:service];
	if (self.ownEntry == service)
		self.ownEntry = nil;
	
	// If moreComing is NO, it means that there are no more messages in the queue from the Bonjour daemon, so we should update the UI.
	// When moreComing is set, we don't update the UI so that it doesn't 'flash'.
	if (!moreComing) {
		[self sortAndUpdateUI];
	}
}	


- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didFindService:(NSNetService*)service moreComing:(BOOL)moreComing {
	// If a service came online, add it to the list and update the table view if no more events are queued.
	if ([service.name isEqual:self.ownName])
		self.ownEntry = service;
	else
		[self.services addObject:service];

	// If moreComing is NO, it means that there are no more messages in the queue from the Bonjour daemon, so we should update the UI.
	// When moreComing is set, we don't update the UI so that it doesn't 'flash'.
	if (!moreComing) {
		[self sortAndUpdateUI];
	}
}	


// This should never be called, since we resolve with a timeout of 0.0, which means indefinite
- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
	[self stopCurrentResolve];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
	[self.tableView reloadData];
}


- (void)netServiceDidResolveAddress:(NSNetService *)service {
	assert(service == self.currentResolve);
	
	[service retain];
	[self stopCurrentResolve];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
	
	[self.delegate browserViewController:self didResolveInstance:service];
	[service release];
}


- (void)cancelAction {
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
	[self.delegate browserViewController:self didResolveInstance:nil];
}


- (void)dealloc {
	// Cleanup any running resolve and free memory
	[self stopCurrentResolve];
	self.services = nil;
	[self.netServiceBrowser stop];
	self.netServiceBrowser = nil;
	[_searchingForServicesString release];
	[_ownName release];
	[_ownEntry release];
	
	[super dealloc];
}


@end
