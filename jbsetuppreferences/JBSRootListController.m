#include "JBSRootListController.h"
#import "../JBSCustomNavigationController.h"
#import "../JBSCompletedViewController.h"

@implementation JBSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)showSetup {
	JBSCompletedViewController *completedVC = [[JBSCompletedViewController alloc] init];
	completedVC.view.backgroundColor = [UIColor whiteColor];

	JBSCustomNavigationController *navCon = [[JBSCustomNavigationController alloc] initWithRootViewController:completedVC];
	navCon.view.backgroundColor = [UIColor whiteColor];

	[self presentViewController:navCon animated:YES completion:nil];
}

@end
