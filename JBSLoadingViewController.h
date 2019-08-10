#import <UIKit/UIKit.h>
#import "JBSErrorDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface JBSLoadingViewController : UIViewController

@property (nonatomic, assign) BOOL root;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, weak) id<JBSErrorDelegate> errorDelegate;

@end

NS_ASSUME_NONNULL_END
