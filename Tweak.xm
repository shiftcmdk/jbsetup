#import "JBSCompletedViewController.h"
#import "JBSCustomNavigationController.h"
#import "JBSPasswordManager.h"
#import "JBSDummyViewController.h"

@interface SBHomeScreenViewController : UIViewController
@end

UIWindow *setupWindow;
JBSDummyViewController *ctrl;
BOOL readyToShowSetupUI = NO;

%hook SBHomeScreenViewController

-(void)viewDidLoad {
    %orig;

    setupWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    setupWindow.windowLevel = UIWindowLevelStatusBar - 10;

    ctrl = [[JBSDummyViewController alloc] init];

    setupWindow.rootViewController = ctrl;
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

        if (ctrl && ctrl.presentedViewController) {
            UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"_statusBar"];
            [statusBar setValue:[UIColor blackColor] forKey:@"foregroundColor"];
            [statusBar setValue:@0 forKey:@"legibilityStyle"];
        }

        if (ctrl && !ctrl.presentedViewController && [sb isShowingHomescreen] && [[JBSPasswordManager sharedManager] shouldChangePassword]) {
            ctrl.view.hidden = NO;
            [setupWindow makeKeyAndVisible];

            UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"_statusBar"];

            ctrl.lastForegroundColor = [statusBar valueForKey:@"foregroundColor"];

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
    setupWindow.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    %orig;

    if (ctrl.presentedViewController) {
        [ctrl dismissViewControllerAnimated:NO completion:nil];
    }

    ctrl.view.hidden = YES;
    setupWindow.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    %orig;

    SpringBoard *sb = (SpringBoard *)[UIApplication sharedApplication];

    readyToShowSetupUI = YES;

    if (ctrl && !ctrl.presentedViewController && [sb isShowingHomescreen] && [[JBSPasswordManager sharedManager] shouldChangePassword]) {
        ctrl.view.hidden = NO;
        [setupWindow makeKeyAndVisible];

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