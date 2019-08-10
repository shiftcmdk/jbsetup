#import "JBSLoadingViewController.h"
#import "JBSPasswordViewController.h"
#import "JBSWelcomeViewController.h"
#import "JBSPasswordManager.h"

@interface JBSLoadingViewController ()

@property (nonatomic, strong) NSLayoutConstraint *centerYConstraint;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, assign) BOOL fakeLoading;
@property (nonatomic, assign) BOOL settingPassword;
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, copy) NSString *errorString;
-(void)finish;

@end

@implementation JBSLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] init];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activityIndicator startAnimating];
    
    self.loadingLabel = [[UILabel alloc] init];
    self.loadingLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.loadingLabel.text = @"";
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[activityIndicator, self.loadingLabel]];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 8.0;
    
    [self.view addSubview:stackView];
    
    [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    self.centerYConstraint = [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor];
    self.centerYConstraint.active = YES;
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.loadingLabel.text = self.root ? @"Setting root password..." : @"Setting mobile password...";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.fakeLoading = YES;
    self.settingPassword = YES;
    self.finished = NO;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        JBSPasswordManager *manager = [JBSPasswordManager sharedManager];

        NSString *error;

        if (self.root) {
            [manager changeRootPassword:self.password error:&error];
        } else {
            [manager changeMobilePassword:self.password error:&error];
        }

        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.settingPassword = NO;

            self.errorString = error;

            [self finish];
        });
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.fakeLoading = NO;

        [self finish];
    });
}

-(void)finish {
    if (!self.settingPassword && !self.fakeLoading && !self.finished) {
        self.finished = YES;

        if (self.errorString) {
            if (self.errorDelegate) {
                [self.errorDelegate settingPasswordDidFail:self.errorString];
            }

            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if (self.root) {
                JBSPasswordViewController *vc = [[JBSPasswordViewController alloc] init];
                vc.view.backgroundColor = [UIColor whiteColor];
                vc.root = NO;
                vc.skippedLastStep = NO;
                
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                JBSWelcomeViewController *vc = [[JBSWelcomeViewController alloc] init];
                vc.view.backgroundColor = [UIColor whiteColor];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.centerYConstraint.constant = -self.navigationController.navigationBar.bounds.size.height;
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
