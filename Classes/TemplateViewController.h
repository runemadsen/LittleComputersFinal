#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

#import "Template.h"
#import "ListButtonViewController.h"
#import "EditButtonViewController.h"
#import "CustomButton.h"
#import "UIToolbarExtend.h"

@class ListButtonViewController;
@class EditButtonViewController;
@class customButton;


@interface TemplateViewController : UIViewController
{
	Template * model;
	ListButtonViewController * listView;
	EditButtonViewController * editView;
	UIToolbar * toolbar;
	BOOL enable;
}

@property (retain, nonatomic) Template * model;
@property (retain, nonatomic) ListButtonViewController *listView;
@property (retain, nonatomic) EditButtonViewController *editView;
@property (nonatomic, retain) UIToolbar *toolbar;

- (id) initWithTemplate:(Template *)newModel;
-(void)switchViews;
-(void)newButton:(id)sender;
-(void)editButton:(id)sender;
-(void)trushButton:(id)sender;
-(void)cancelButton:(id)sender;
-(void)doneButton:(id)sender;
-(void)displayListToolbar;
-(void)displayEditToolbar;

@end







