#import "JBSCustomNavigationController.h"

@implementation JBSCustomNavigationController

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? [super supportedInterfaceOrientations] : UIInterfaceOrientationMaskPortrait;
}

@end