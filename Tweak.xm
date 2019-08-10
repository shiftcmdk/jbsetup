#import "JBSCompletedViewController.h"
#import "JBSCustomNavigationController.h"
#import "JBSPasswordManager.h"

@interface SBHomeScreenViewController : UIViewController
@end

SBHomeScreenViewController *ctrl;
BOOL readyToShowSetupUI = NO;

%hook SBHomeScreenViewController

-(void)viewDidLoad {
	%orig;

	ctrl = self;
}

%end

@interface SpringBoard: UIApplication

-(BOOL)isShowingHomescreen;

@end

%hook SpringBoard

-(void)_updateHomeScreenPresenceNotification:(id)arg1 {
	%orig;

	if (readyToShowSetupUI) {
		SpringBoard *sb = (SpringBoard *)[UIApplication sharedApplication];

		if (ctrl && !ctrl.presentedViewController && [sb isShowingHomescreen] && [[JBSPasswordManager sharedManager] shouldChangePassword]) {
			JBSCompletedViewController *completedVC = [[JBSCompletedViewController alloc] init];
			completedVC.view.backgroundColor = [UIColor whiteColor];

			JBSCustomNavigationController *navCon = [[JBSCustomNavigationController alloc] initWithRootViewController:completedVC];
			navCon.view.backgroundColor = [UIColor whiteColor];

			[ctrl presentViewController:navCon animated:YES completion:nil];
		}
	}
}

%end

%hook SBDashBoardViewController

-(void)viewDidAppear:(BOOL)animated {
	%orig;

	readyToShowSetupUI = NO;
}

-(void)viewDidDisappear:(BOOL)animated {
	%orig;

	SpringBoard *sb = (SpringBoard *)[UIApplication sharedApplication];

	readyToShowSetupUI = YES;

	if (ctrl && !ctrl.presentedViewController && [sb isShowingHomescreen] && [[JBSPasswordManager sharedManager] shouldChangePassword]) {
		JBSCompletedViewController *completedVC = [[JBSCompletedViewController alloc] init];
		completedVC.view.backgroundColor = [UIColor whiteColor];

		JBSCustomNavigationController *navCon = [[JBSCustomNavigationController alloc] initWithRootViewController:completedVC];
		navCon.view.backgroundColor = [UIColor whiteColor];

		[ctrl presentViewController:navCon animated:YES completion:nil];
	}
}

%end

/*%ctor {
	NSString *uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;

    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.shiftcmdk.jbsetup.preferences"];

	[defaults removeObjectForKey:uuid];
}*/