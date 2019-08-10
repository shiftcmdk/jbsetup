#import <UIKit/UIKit.h>
#import "JBSContinueButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface JBSSetupViewController : UIViewController

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) JBSContinueButton *continueButton;
@property (nonatomic, assign) BOOL hideContinueButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

-(void)continueButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
