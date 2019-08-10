@interface JBSPasswordManager: NSObject

+(instancetype)sharedManager;
-(void)changeRootPassword:(NSString *)password error:(NSString **)error;
-(void)changeMobilePassword:(NSString *)password error:(NSString **)error;
-(BOOL)shouldChangePassword;
-(void)passwordChanged;

@end