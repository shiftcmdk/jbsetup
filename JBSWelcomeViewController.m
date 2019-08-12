#import "JBSWelcomeViewController.h"
#import "JBSPasswordManager.h"
#import "JBSDummyViewController.h"

@interface JBSWelcomeViewController ()

@property (nonatomic, strong) NSLayoutConstraint *centerYConstraint;

@end

@implementation JBSWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[JBSPasswordManager sharedManager] passwordChanged];
    
    self.navigationItem.hidesBackButton = YES;
    
    UILabel *welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.text = [NSString stringWithFormat:@"Welcome to your jailbroken %@", [UIDevice currentDevice].model];
    welcomeLabel.numberOfLines = 0;
    welcomeLabel.font = [UIFont systemFontOfSize:34.0 weight:UIFontWeightBold];
    
    [self.view addSubview:welcomeLabel];
    
    [welcomeLabel.leadingAnchor constraintEqualToAnchor:self.view.readableContentGuide.leadingAnchor].active = YES;
    [welcomeLabel.trailingAnchor constraintEqualToAnchor:self.view.readableContentGuide.trailingAnchor].active = YES;
    self.centerYConstraint = [welcomeLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor];
    self.centerYConstraint.active = YES;
    
    UIButton *getStartedButton = [UIButton buttonWithType:UIButtonTypeSystem];
    getStartedButton.translatesAutoresizingMaskIntoConstraints = NO;
    [getStartedButton setTitle:@"Get Started" forState:UIControlStateNormal];
    getStartedButton.titleLabel.font = [UIFont systemFontOfSize:23.0 weight:UIFontWeightRegular];
    [getStartedButton addTarget:self action:@selector(getStartedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:getStartedButton];
    
    [getStartedButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [getStartedButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [getStartedButton.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.5].active = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.centerYConstraint.constant = -self.navigationController.navigationBar.bounds.size.height - 15.0;
}

-(void)getStartedButtonTapped:(UIButton *)sender {
    __weak UIViewController *presentingVC = self.presentingViewController;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if ([presentingVC isKindOfClass:[JBSDummyViewController class]]) {
            presentingVC.view.hidden = YES;
            [presentingVC.view removeFromSuperview];
            UIWindow *window = [presentingVC valueForKey:@"window"];
            window.hidden = YES;
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
