#import "TemplateViewController.h"
#import "TemplatesLoader.h"
#import "AddTemplateViewController.h"
#import "Template.h"

@interface RootViewController : UITableViewController <UITableViewDelegate> 
{	
	TemplateViewController * templateView;
	AddTemplateViewController * addTemplateView;
	TemplatesLoader * loader;
}

@property (nonatomic, retain) TemplateViewController * templateView;
@property (nonatomic, retain) AddTemplateViewController * addTemplateView;
@property (nonatomic, retain) TemplatesLoader * loader;

- (void) saveNewTemplate:(id)sender;
- (void) saveAllData:(id)sender;

@end
