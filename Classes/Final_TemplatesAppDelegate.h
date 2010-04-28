//
//  Final_TemplatesAppDelegate.h
//  Final-Templates
//
//  Created by Rune Madsen on 4/7/10.
//  Copyright New York University 2010. All rights reserved.
//

@interface Final_TemplatesAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow * window;
    UINavigationController * navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

