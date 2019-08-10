#import "JBSPasswordViewController.h"
#import "JBSLoadingViewController.h"
#import "JBSWelcomeViewController.h"
#import "JBSErrorDelegate.h"

@interface JBSPasswordViewController () <UITextFieldDelegate, JBSErrorDelegate>

@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *verifyTextField;
@property (nonatomic, copy) NSString *errorString;
-(void)showJBSLoadingViewController;

@end

@implementation JBSPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *topSeparatorView = [[UIView alloc] init];
    topSeparatorView.translatesAutoresizingMaskIntoConstraints = NO;
    topSeparatorView.backgroundColor = [UIColor colorWithRed:237.0 / 255.0 green:237.0 / 255.0 blue:237.0 / 255.0 alpha:1.0];
    
    [self.contentView addSubview:topSeparatorView];
    
    [topSeparatorView.leadingAnchor constraintEqualToAnchor:self.contentView.readableContentGuide.leadingAnchor].active = YES;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [topSeparatorView.trailingAnchor constraintEqualToAnchor:self.contentView.readableContentGuide.trailingAnchor].active = YES;
    } else {
        [topSeparatorView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    }
    
    [topSeparatorView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:25.0].active = YES;
    [topSeparatorView.heightAnchor constraintEqualToConstant:1.0].active = YES;
    
    UILabel *passwordLabel = [[UILabel alloc] init];
    passwordLabel.translatesAutoresizingMaskIntoConstraints = NO;
    passwordLabel.text = @"Password";
    passwordLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    
    [self.contentView addSubview:passwordLabel];
    
    [passwordLabel.leadingAnchor constraintEqualToAnchor:topSeparatorView.leadingAnchor].active = YES;
    [passwordLabel.topAnchor constraintEqualToAnchor:topSeparatorView.bottomAnchor].active = YES;
    [passwordLabel.heightAnchor constraintEqualToConstant:60.0].active = YES;
    
    UIView *bottomSeparatorView = [[UIView alloc] init];
    bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = NO;
    bottomSeparatorView.backgroundColor = [UIColor colorWithRed:237.0 / 255.0 green:237.0 / 255.0 blue:237.0 / 255.0 alpha:1.0];
    
    [self.contentView addSubview:bottomSeparatorView];
    
    [bottomSeparatorView.leadingAnchor constraintEqualToAnchor:topSeparatorView.leadingAnchor].active = YES;
    [bottomSeparatorView.trailingAnchor constraintEqualToAnchor:topSeparatorView.trailingAnchor].active = YES;
    
    [bottomSeparatorView.topAnchor constraintEqualToAnchor:passwordLabel.bottomAnchor].active = YES;
    [bottomSeparatorView.heightAnchor constraintEqualToConstant:1.0].active = YES;
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordTextField.placeholder = @"Required";
    self.passwordTextField.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    
    [self.contentView addSubview:self.passwordTextField];
    
    [self.passwordTextField.trailingAnchor constraintEqualToAnchor:topSeparatorView.trailingAnchor].active = YES;
    [self.passwordTextField.topAnchor constraintEqualToAnchor:passwordLabel.topAnchor].active = YES;
    [self.passwordTextField.bottomAnchor constraintEqualToAnchor:passwordLabel.bottomAnchor].active = YES;
    
    UILabel *verifyLabel = [[UILabel alloc] init];
    verifyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    verifyLabel.text = @"Verify";
    verifyLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    
    [self.contentView addSubview:verifyLabel];
    
    [verifyLabel.leadingAnchor constraintEqualToAnchor:topSeparatorView.leadingAnchor].active = YES;
    [verifyLabel.topAnchor constraintEqualToAnchor:bottomSeparatorView.bottomAnchor].active = YES;
    [verifyLabel.heightAnchor constraintEqualToAnchor:passwordLabel.heightAnchor].active = YES;
    
    UIView *bottom1SeparatorView = [[UIView alloc] init];
    bottom1SeparatorView.translatesAutoresizingMaskIntoConstraints = NO;
    bottom1SeparatorView.backgroundColor = [UIColor colorWithRed:237.0 / 255.0 green:237.0 / 255.0 blue:237.0 / 255.0 alpha:1.0];
    
    [self.contentView addSubview:bottom1SeparatorView];
    
    [bottom1SeparatorView.leadingAnchor constraintEqualToAnchor:topSeparatorView.leadingAnchor].active = YES;
    [bottom1SeparatorView.trailingAnchor constraintEqualToAnchor:topSeparatorView.trailingAnchor].active = YES;
    
    [bottom1SeparatorView.topAnchor constraintEqualToAnchor:verifyLabel.bottomAnchor].active = YES;
    [bottom1SeparatorView.heightAnchor constraintEqualToConstant:1.0].active = YES;
    
    self.verifyTextField = [[UITextField alloc] init];
    self.verifyTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.verifyTextField.placeholder = @"Retype password";
    self.verifyTextField.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.verifyTextField.secureTextEntry = YES;
    self.verifyTextField.returnKeyType = UIReturnKeyDone;
    
    [self.contentView addSubview:self.verifyTextField];
    
    [self.verifyTextField.leadingAnchor constraintEqualToAnchor:self.passwordTextField.leadingAnchor].active = YES;
    [self.verifyTextField.trailingAnchor constraintEqualToAnchor:topSeparatorView.trailingAnchor].active = YES;
    [self.verifyTextField.topAnchor constraintEqualToAnchor:verifyLabel.topAnchor].active = YES;
    [self.verifyTextField.bottomAnchor constraintEqualToAnchor:verifyLabel.bottomAnchor].active = YES;
    
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeSystem];
    skipButton.translatesAutoresizingMaskIntoConstraints = NO;
    [skipButton setTitle:@"Skip this step" forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    [skipButton addTarget:self action:@selector(skipButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:skipButton];
    
    [skipButton.trailingAnchor constraintEqualToAnchor:self.contentView.readableContentGuide.trailingAnchor].active = YES;
    [skipButton.topAnchor constraintEqualToAnchor:bottom1SeparatorView.bottomAnchor constant:15.0].active = YES;
    [skipButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;

    UIButton *moreInfoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    moreInfoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [moreInfoButton setTitle:@"More Info" forState:UIControlStateNormal];
    moreInfoButton.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    [moreInfoButton addTarget:self action:@selector(moreInfoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:moreInfoButton];
    
    [moreInfoButton.leadingAnchor constraintEqualToAnchor:self.contentView.readableContentGuide.leadingAnchor].active = YES;
    [moreInfoButton.topAnchor constraintEqualToAnchor:bottom1SeparatorView.bottomAnchor constant:15.0].active = YES;
    
    CGFloat textFieldMargin = fmax(passwordLabel.intrinsicContentSize.width, verifyLabel.intrinsicContentSize.width);
    
    [self.passwordTextField.leadingAnchor constraintEqualToAnchor:topSeparatorView.leadingAnchor constant:textFieldMargin + 30.0].active = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextButtonTapped:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.hideContinueButton = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.passwordTextField.delegate = self;
    self.verifyTextField.delegate = self;
    
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.verifyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ Password", self.root ? @"Root" : @"Mobile"];
    self.descriptionLabel.text = [NSString stringWithFormat:@"Set a new password for the %@ user. \nThis will make your device more secure.", self.root ? @"root" : @"mobile"];
    
    self.navigationItem.hidesBackButton = !self.skippedLastStep;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.errorString) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:self.errorString preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];

        self.errorString = nil;
    }
}

-(void)showJBSLoadingViewController {
    JBSLoadingViewController *vc = [[JBSLoadingViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.root = self.root;
    vc.password = self.passwordTextField.text;
    vc.errorDelegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)textFieldDidChange:(UITextField *)sender {
    self.navigationItem.rightBarButtonItem.enabled = [self.passwordTextField.text isEqualToString:self.verifyTextField.text] && self.passwordTextField.text.length > 4;
}

-(void)nextButtonTapped:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];

    if ([self.passwordTextField.text isEqualToString:@"alpine"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"\"alpine\" is the default password. Do you really want to continue?" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showJBSLoadingViewController];
        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:continueAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self showJBSLoadingViewController];
    }
}

- (void)keyboardWillShow:(NSNotification*)notification {
    CGRect frame = [[notification.userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat additionalInset = self.view.bounds.size.height - self.scrollView.bounds.size.height;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, frame.size.height - self.continueButton.bounds.size.height - additionalInset, 0.0);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, frame.size.height - self.continueButton.bounds.size.height - additionalInset, 0.0);
}

- (void)keyboardWillHide:(NSNotification*)notification {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

-(void)skipButtonTapped:(UIButton *)sender {
    NSString *user = self.root ? @"root" : @"mobile";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:[NSString stringWithFormat:@"Not setting a password for the %@ user will leave your device vulnerable to potential attacks. You can still set the %@ password via the command line later on. Do you really want to skip this step?", user, user] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *skipAction = [UIAlertAction actionWithTitle:@"Skip" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.root) {
            JBSPasswordViewController *vc = [[JBSPasswordViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.root = NO;
            vc.skippedLastStep = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            JBSWelcomeViewController *vc = [[JBSWelcomeViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:skipAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)moreInfoButtonTapped:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"What is this?" message:@"Most jailbreaks install a tool that allows you to connect to your device from a computer with a username and password. iOS has a default password set for both the root and mobile user. This password is well known. An attacker could scan for your device in a public WiFi for example and gain full access to your device by using the default password. It is therefore advised to change the root and mobile user password immediately after jailbreaking. It must be at least 5 characters long." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        [self.verifyTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

-(void)settingPasswordDidFail:(NSString *)reason {
    self.errorString = reason;
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
