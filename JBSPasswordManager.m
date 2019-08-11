#import "JBSPasswordManager.h"
#import "jbspw/JBSPWStatus.h"
#include <spawn.h>

@implementation JBSPasswordManager

+(instancetype)sharedManager {
    static JBSPasswordManager *sharedManager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedManager = [[JBSPasswordManager alloc] init];
    });

    return sharedManager;
}

-(void)changeRootPassword:(NSString *)password error:(NSString **)error {
    [self changePassword:@"root" password:password error:error];
}

-(void)changeMobilePassword:(NSString *)password error:(NSString **)error {
    [self changePassword:@"mobile" password:password error:error];
}

-(void)changePassword:(NSString *)user password:(NSString *)password error:(NSString **)error {
    NSString *command = [NSString stringWithFormat:@"/usr/bin/jbspw %@", user];

    FILE *fp = popen([command UTF8String], "w");

    NSString *errorString;

    if (fp) {
        if (fputs([password UTF8String], fp) == EOF) {
            errorString = @"An internal error occured. (EOF)";

            pclose(fp);
        } else {
            int status = pclose(fp);

            if (WIFEXITED(status)) {
                switch WEXITSTATUS(status) {
                    case 0:
                        break;
                    case JBSPWStatusCouldNotElevate:
                        errorString = @"Could not elevate permissions in order to change the password.";
                        break;
                    case JBSPWStatusInvalidPassword:
                        errorString = @"The password has to be at least 5 characters long.";
                        break;
                    case JBSPWStatusNoUser:
                        errorString = @"An internal error occured. (no user)";
                        break;
                    case JBSPWStatusInvalidUser:
                        errorString = @"An internal error occured. (invalid user)";
                        break;
                    case JBSPWStatusCouldNotReadFile:
                        errorString = @"An internal error occured. (could not read file)";
                        break;
                    case JBSPWStatusCouldNotFindUser:
                        errorString = @"An internal error occured. (could not find user)";
                        break;
                    case JBSPWStatusFailedToEncrypt:
                        errorString = @"Failed to encrypt the password.";
                        break;
                    case JBSPWStatusInvalidFileFormat:
                        errorString = @"An internal error occured. (invalid file format)";
                        break;
                    case JBSPWStatusCouldNotWritePassword:
                        errorString = @"An internal error occured. (could not write password)";
                        break;
                    default:
                        errorString = [NSString stringWithFormat:@"An internal error occured. (exit status: %i)", WEXITSTATUS(status)];
                        break;
                }
            } else {
                errorString = @"An internal error occured.";
            }
        }
    } else {
        errorString = @"An internal error occured. (popen)";
    }

    if (errorString) {
        *error = [NSString stringWithFormat:@"%@ Please try again. If this does not work you can skip this step and set the password via the command line later on.", errorString];
    }
}

-(void)passwordChanged {
    // the master.passwd modified date sometimes does not update immediately so we just use this as the modified date
    NSDate *changedDate = [NSDate date];

    pid_t pid;
    int status;

    // Update master.passwd modification date
    const char *args[] = {"jbstouch", NULL};
    posix_spawn(&pid, "/usr/bin/jbstouch", NULL, NULL, (char* const*)args, NULL);
    
    waitpid(pid, &status, WEXITED);

    NSString *uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;

    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.shiftcmdk.jbsetup.preferences"];

    [defaults setDouble:changedDate.timeIntervalSince1970 forKey:uuid];
}

-(BOOL)shouldChangePassword {
    NSString *uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;

    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.shiftcmdk.jbsetup.preferences"];

    id savedTimeInterval = [defaults objectForKey:uuid];

    if (savedTimeInterval == nil) {
        return YES;
    }

    NSError *err;

    NSDictionary *fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:@"/etc/master.passwd" error:&err];

    if (err) {
        return NO;
    }

    // the master.passwd could get restored so we check for the modified date
    NSDate *modifiedDate = [fileAttribs objectForKey:NSFileModificationDate];

    if (!modifiedDate) {
        return YES;
    }

    return modifiedDate.timeIntervalSince1970 < [savedTimeInterval doubleValue];
}

@end