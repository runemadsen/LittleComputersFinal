//
//  AddTemplateViewController.h
//  Final-Templates
//
//  Created by Rune Madsen on 4/8/10.
//  Copyright 2010 New York University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddTemplateViewController : UIViewController {

	IBOutlet UITextField * templateName;
	IBOutlet UIButton * saveButton;
}

@property (nonatomic, retain) IBOutlet UITextField * templateName;

- (IBAction) save:(id)sender;

@end
