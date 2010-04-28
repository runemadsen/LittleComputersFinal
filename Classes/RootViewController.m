#import "RootViewController.h"

@implementation RootViewController
@synthesize templateView;
@synthesize addTemplateView;
@synthesize loader;

/* View Loaded
______________________________________________________________ */

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
	[dc addObserver:self selector:@selector(saveNewTemplate:) name:@"SaveNewTemplate" object:NULL];
	[dc addObserver:self selector:@selector(saveAllData:) name:@"ApplicationTerminate" object:NULL];
	
	// Load data
	
	NSString *fileName = @"SavedTemplates";
	
	if([[LCFileHelpers allDocuments] containsObject:fileName])
	{
		loader = (TemplatesLoader *)[[NSKeyedUnarchiver unarchiveObjectWithFile:[LCFileHelpers pathToFileInDocuments:fileName]] retain];
	}
	else
	{		
		loader = [[TemplatesLoader alloc] initEmpty];
	}
	
	// Style background
	[self.tableView setBackgroundColor:[UIColor colorWithRed:(float) 21.0 / 255.0 green:(float) 24.0 / 255.0 blue:(float) 18.0 / 255.0 alpha:1]];
	self.tableView.separatorColor = [UIColor colorWithWhite:.12 alpha:1];

	self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
	
	self.title = @"Templates";
}

/* Add / Save New Template 
 ______________________________________________________________ */

- (void)addItem:sender 
{
    
	if (addTemplateView == nil) 
	{
        addTemplateView = [[AddTemplateViewController alloc] init];
    }
	
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:addTemplateView];
    [[self navigationController] presentModalViewController:navigationController animated:YES];
    [navigationController release];
}

- (void) saveNewTemplate:(id)sender
{	
	Template * newTemplate = [[Template alloc] initWithName:[addTemplateView.templateName text]];
	[loader addRow:newTemplate];
	
	[self.tableView reloadData];
	
	[newTemplate release];
}

/* Save all data
 ______________________________________________________________ */

- (void) saveAllData:(id)sender
{	
	NSString * filePath = [LCFileHelpers pathToFileInDocuments:@"SavedTemplates"];
	
	BOOL noErr = [NSKeyedArchiver archiveRootObject:loader toFile:filePath];
	
	if(!noErr)
	{
		NSLog(@"Oops! something went wrong trying to save that person.");
	}
}

/* Table View Methods
 ______________________________________________________________ */

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

/* Define rows in table view
 ______________________________________________________________ */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{	
	return loader.templates.count;
}


/* Define how a cell looks like
 ______________________________________________________________ */

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[cell setBackgroundColor:[UIColor colorWithRed:(float) 21.0 / 255.0 green:(float) 24.0 / 255.0 blue:(float) 18.0 / 255.0 alpha:1]];
	cell.textLabel.textColor = [UIColor colorWithWhite:.85 alpha:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	Template * t = (Template *) [loader.templates objectAtIndex:indexPath.row];
	
	[cell.textLabel setText:t.name];

    return cell;
}


/* When a row is selected
 ______________________________________________________________ */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	Template * t = (Template *) [loader.templates objectAtIndex:indexPath.row];
	
	//if(self.templateView == nil)
	//{
		//[self.templateView release];
		TemplateViewController * aView = [[TemplateViewController alloc] initWithTemplate:t];
		self.templateView = aView;
		[aView release];
	//}
	
	t = (Template *) [loader.templates objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:self.templateView animated:YES];
}


/* When a row is deleted
 ______________________________________________________________ */

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        // Delete the row from the data source.
        [loader.templates removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) 
	{
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}

-(void) tableView: (UITableView *) tableView moveRowAtIndexPath: (NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
	[loader reorderFrom:[oldPath row] to:[newPath row]];
}

/* Error
 ______________________________________________________________ */

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

/* Unload
 ______________________________________________________________ */

- (void)viewDidUnload 
{
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

/* Dealloc
 ______________________________________________________________ */

- (void)dealloc 
{
    [super dealloc];
	[loader dealloc];
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }*/


@end

