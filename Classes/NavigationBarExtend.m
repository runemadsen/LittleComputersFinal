#import "NavigationBarExtend.h"

@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect {
    // Drawing code 
    UIImage *img = [UIImage imageNamed: @"topbar.png"];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, CGRectMake(0, 0, 320, self.frame.size.height), img.CGImage);
	
}

@end
