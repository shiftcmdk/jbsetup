#import "JBSCompletedViewController.h"
#import "JBSCustomNavigationController.h"
#import "JBSPasswordManager.h"
#import "JBSDummyViewController.h"

@interface SBHomeScreenViewController : UIViewController
@end

JBSDummyViewController *ctrl;
BOOL readyToShowSetupUI = NO;

%hook SBHomeScreenViewController

-(void)viewDidLoad {
    %orig;

    ctrl = [[JBSDummyViewController alloc] init];
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
            UIWindow *window = [[UIApplication sharedApplication] valueForKey:@"_statusBarWindow"];

            ctrl.view.hidden = NO;

            if (!ctrl.view.superview) {
                [window insertSubview:ctrl.view atIndex:0];
            }

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

    if (ctrl.presentedViewController) {
        [ctrl dismissViewControllerAnimated:NO completion:nil];
    }
    ctrl.view.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    %orig;

    if (ctrl.presentedViewController) {
        [ctrl dismissViewControllerAnimated:NO completion:nil];
    }

    ctrl.view.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    %orig;

    SpringBoard *sb = (SpringBoard *)[UIApplication sharedApplication];

    readyToShowSetupUI = YES;

    UIWindow *window = [[UIApplication sharedApplication] valueForKey:@"_statusBarWindow"];

    if (ctrl && !ctrl.presentedViewController && [sb isShowingHomescreen] && [[JBSPasswordManager sharedManager] shouldChangePassword]) {
        ctrl.view.hidden = NO;

        if (!ctrl.view.superview) {
            [window insertSubview:ctrl.view atIndex:0];
        }

        UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"_statusBar"];

        ctrl.lastForegroundColor = [statusBar valueForKey:@"foregroundColor"];

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