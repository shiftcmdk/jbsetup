#import "JBSCustomNavigationController.h"

@implementation JBSCustomNavigationController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    BOOL isSpringBoard = [[NSBundle mainBundle].bundleIdentifier isEqual:@"com.apple.springboard"];

    if (isSpringBoard) {
        UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"_statusBar"];
        [statusBar setValue:[UIColor blackColor] forKey:@"foregroundColor"];
        [statusBar setValue:@0 forKey:@"legibilityStyle"];
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? [super supportedInterfaceOrientations] : UIInterfaceOrientationMaskPortrait;
}

@end