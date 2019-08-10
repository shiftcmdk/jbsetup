#import "JBSSetupViewController.h"

@interface JBSSetupViewController ()

@property (nonatomic, strong) NSLayoutConstraint *continueHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *scrollViewBottomConstraint;
@property (nonatomic, strong) UIView *scrollViewContentView;

@end

@implementation JBSSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hideContinueButton = NO;
    
    self.continueButton = [JBSContinueButton buttonWithType:UIButtonTypeCustom];
    self.continueButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    self.continueButton.backgroundColor = [UIColor colorWithRed:0.0 green:122.0 / 255.0 blue:1.0 alpha:1.0];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.continueButton.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    self.continueButton.layer.cornerRadius = 8.0;
    [self.continueButton addTarget:self action:@selector(continueButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.continueButton];
    
    [self.continueButton.leadingAnchor constraintEqualToAnchor:self.view.readableContentGuide.leadingAnchor constant:4.0].active = YES;
    [self.continueButton.trailingAnchor constraintEqualToAnchor:self.view.readableContentGuide.trailingAnchor constant:-4.0].active = YES;
    [self.continueButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-44.0].active = YES;
    self.continueHeightConstraint = [self.continueButton.heightAnchor constraintEqualToConstant:50.0];
    self.continueHeightConstraint.active = YES;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.preservesSuperviewLayoutMargins = YES;
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    self.scrollViewBottomConstraint = [self.scrollView.bottomAnchor constraintEqualToAnchor:self.continueButton.topAnchor constant:-10.0];
    self.scrollViewBottomConstraint.active = YES;
    
    self.scrollViewContentView = [[UIView alloc] init];
    self.scrollViewContentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollViewContentView.preservesSuperviewLayoutMargins = YES;
    
    [self.scrollView addSubview:self.scrollViewContentView];
    
    [self.scrollViewContentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor].active = YES;
    [self.scrollViewContentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor].active = YES;
    [self.scrollViewContentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor].active = YES;
    [self.scrollViewContentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor].active = YES;
    [self.scrollViewContentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor].active = YES;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"";
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:34.0 weight:UIFontWeightBold];
    
    [self.scrollViewContentView addSubview:self.titleLabel];
    
    [self.titleLabel.topAnchor constraintEqualToAnchor:self.scrollViewContentView.topAnchor constant:12.0].active = YES;
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.scrollViewContentView.readableContentGuide.leadingAnchor constant:4.0].active = YES;
    [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.scrollViewContentView.readableContentGuide.trailingAnchor constant:-4.0].active = YES;
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.text = @"";
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    
    [self.scrollViewContentView addSubview:self.descriptionLabel];
    
    [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor].active = YES;
    [self.descriptionLabel.trailingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor].active = YES;
    [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:8.0].active = YES;
    
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.preservesSuperviewLayoutMargins = YES;
    
    [self.scrollViewContentView addSubview:self.contentView];
    
    [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollViewContentView.leadingAnchor].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollViewContentView.trailingAnchor].active = YES;
    [self.contentView.topAnchor constraintEqualToAnchor:self.descriptionLabel.bottomAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollViewContentView.bottomAnchor].active = YES;
    
    //self.scrollViewContentView.backgroundColor = [UIColor lightGrayColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

-(void)continueButtonTapped:(UIButton *)sender {
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.continueHeightConstraint.constant = self.hideContinueButton ? 0.0 : 50.0;
    self.scrollViewBottomConstraint.constant = self.hideContinueButton ? 0.0 : -10.0;
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
