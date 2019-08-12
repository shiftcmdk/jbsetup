#import "JBSCompletedViewController.h"
#import "JBSPasswordViewController.h"

@interface JBSCompletedViewController ()

@end

@implementation JBSCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"Jailbreak Completed";
    self.descriptionLabel.text = [NSString stringWithFormat:@"Your %@ was jailbroken successfully. \nThere are just a few more steps to follow, and then you’re done!", [UIDevice currentDevice].model];
}

-(void)continueButtonTapped:(UIButton *)sender {
    JBSPasswordViewController *vc = [[JBSPasswordViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.root = YES;
    vc.skippedLastStep = NO;
    
    [self.navigationController pushViewController:vc animated:YES];
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
