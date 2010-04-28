#import <Foundation/Foundation.h>
#import "CustomButton.h"
#import "Three20/Three20.h"
#import "ButtonStylesheet.h"

@interface CustomButtonView : UIView
{
	CustomButton * model;	
	UIButton * button;
}

@property (retain, nonatomic) CustomButton * model;
@property (retain, nonatomic) UIButton * button;

- (id)initWithFrame:(CGRect)frame model:(CustomButton *)newModel;
-(IBAction)buttonClick:(id)sender;

@end
