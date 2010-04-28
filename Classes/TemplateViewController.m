#import "TemplateViewController.h"

@implementation TemplateViewController
@synthesize listView;
@synthesize editView;
@synthesize toolbar;
@synthesize model;

-(id) initWithTemplate:(Template *)newModel
{
	self = [super init];
	
	if(self != nil)
	{
		model = newModel;
	}
	
	return self;
}

-(void)viewDidLoad
{	
	ListButtonViewController * listB = [[ListButtonViewController alloc] init];
	self.listView = listB;
	[self.view insertSubview:listB.view atIndex:0];
	[listB release];
	
	[self.listView refreshButtons:model.buttons];
	
	EditButtonViewController * editB = [[EditButtonViewController alloc] init];
	self.editView = editB;
	[super viewDidLoad];
	[editB release];
	
	[self displayListToolbar];
	
	[self.view setBackgroundColor:[UIColor colorWithRed:(float) 21.0 / 255.0 green:(float) 24.0 / 255.0 blue:(float) 18.0 / 255.0 alpha:1]];
	
	enable = YES;
}

-(void)switchViews
{
	if (self.editView.view.superview == nil) 
	{
		[listView.view removeFromSuperview];
		[self.view insertSubview:editView.view atIndex:0];
	} 
	else 
	{
		[editView.view removeFromSuperview];
		[self.view insertSubview:listView.view atIndex:0];
		[self.listView viewDidLoad];
	}
}

-(IBAction)newButton:(id)sender
{
	[self switchViews];
	[self displayEditToolbar];
}

-(IBAction)editButton:(id)sender
{
	for(int i = 0; i < [[self.listView.view subviews] count]; i++)
	{
		BOOL en= [[[self.listView.view subviews] objectAtIndex:i] button].enabled;
		
		[[[[self.listView.view subviews] objectAtIndex:i] button] setEnabled:!en];
	}
	
	//[self.listView viewDidLoad];
}

-(IBAction)trushButton:(id)sender
{
	
}

-(IBAction)cancelButton:(id)sender
{
	[self switchViews];
	[self displayListToolbar];
}

-(IBAction)doneButton:(id)sender
{
	// new model, and refresh buttons on listview
	
	CustomButton * buttonModel = [[CustomButton alloc] init];
	buttonModel.name = [[editView firstTextField] text];
	//buttonModel.shortcut = [[editView secondTextField] text];
	
	// loop through array and make a new array with strings that gets assigned to model
	NSMutableArray * shortcuts = [[NSMutableArray alloc] init];
	
	for(int i = 0; i < [[[editView shortcutField] cellViews] count]; i++) 
	{
		TTPickerViewCell * cell = [[[editView shortcutField] cellViews] objectAtIndex:i];
		
		[shortcuts addObject: [cell label]];
	}
	
	buttonModel.shortcuts = shortcuts;
	buttonModel.location = CGPointMake(20, 20);
	
	// push to model
	[self.model.buttons addObject:buttonModel];
	
	// update views in list
	[self.listView refreshButtons:self.model.buttons];
	
	[self switchViews];
	[self displayListToolbar];
	
	[buttonModel release];
}

-(void)displayListToolbar
{
	[self.toolbar removeFromSuperview];
	//Add buttons
	
	UIBarButtonItem * newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			   target:self
																			   action:@selector(newButton:)];
	
	UIBarButtonItem * editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																				target:self
																				action:@selector(editButton:)];
	
	UIBarButtonItem * deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
																				  target:self
																				  action:@selector(trushButton:)];
	
	NSArray * items = [NSArray arrayWithObjects: newButton, deleteButton, editButton, nil];
	
	UIToolbar * tools = [UIToolbarExtend new];
	

	
	tools.frame = CGRectMake(0, 0, 133, 44.01);
	[tools setItems:items animated:NO];
	
	//[tools setBarStyle:UIBarStyleBlackTranslucent];
	[tools setTranslucent:YES];
	
	// these should change the button colors but they dont
	tools.tintColor = [UIColor colorWithRed:(float) 21.0 / 255.0 green:(float) 24.0 / 255.0 blue:(float) 18.0 / 255.0 alpha:1];
	
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
	
	//release buttons
	[newButton release];
	[editButton release];
	[deleteButton release];	
}

-(void)displayEditToolbar
{
	UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				  action:@selector(cancelButton:)];
	
	UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																				target:self
																				action:@selector(doneButton:)];
	
	NSArray *items = [NSArray arrayWithObjects: cancelButton, doneButton, nil];	
	
	UIToolbar * tools =[UIToolbarExtend new];

	tools.frame = CGRectMake(0, 0, 133, 44.01);
	[tools setItems:items animated:NO];
	
	//[tools setBarStyle:UIBarStyleBlackTranslucent];
	[tools setTranslucent:YES];
	
	// these should change the button colors but they dont
	tools.tintColor = [UIColor colorWithRed:(float) 21.0 / 255.0 green:(float) 24.0 / 255.0 blue:(float) 18.0 / 255.0 alpha:1];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
	
	[cancelButton release];
	[doneButton release];
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	if (self.listView.view.superview==nil) 
	{
		self.listView=nil;
	} 
	else 
	{
		self.editView=nil;
	}
    
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
}


@end
