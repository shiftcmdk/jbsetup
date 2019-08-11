#import "JBSDummyViewController.h"

@interface JBSDummyViewController ()
@end

@implementation JBSDummyViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.lastForegroundColor) {
        UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"_statusBar"];
        [statusBar setValue:self.lastForegroundColor forKey:@"foregroundColor"];
    }
    self.lastForegroundColor = nil;
}

@end