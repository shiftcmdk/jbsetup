#import "JBSPWStatus.h"
#include <dlfcn.h>
#include <unistd.h>

#define FLAG_PLATFORMIZE (1 << 1)

void patch_setuidandplatformize() {
  void* handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
  if (!handle) return;

  // Reset errors
  dlerror();

  typedef void (*fix_setuid_prt_t)(pid_t pid);
  fix_setuid_prt_t setuidptr = (fix_setuid_prt_t)dlsym(handle, "jb_oneshot_fix_setuid_now");

  typedef void (*fix_entitle_prt_t)(pid_t pid, uint32_t what);
  fix_entitle_prt_t entitleptr = (fix_entitle_prt_t)dlsym(handle, "jb_oneshot_entitle_now");

  setuidptr(getpid());

  setuid(0);

  const char *dlsym_error = dlerror();
  if (dlsym_error) {
    return;
  }

  entitleptr(getpid(), FLAG_PLATFORMIZE);
}

int main(int argc, char **argv, char **envp) {
	patch_setuidandplatformize();

	if (setuid(0) != 0 || setgid(0) != 0) {
		return JBSPWStatusCouldNotElevate;
	}

	NSString *pass = [[NSString alloc] initWithData:[NSFileHandle fileHandleWithStandardInput].availableData encoding:NSUTF8StringEncoding];

	if (pass.length < 5) {
		return JBSPWStatusInvalidPassword;
	}

	if (argc < 2) {
		return JBSPWStatusNoUser;
	}

	NSString *user = [NSString stringWithUTF8String:argv[1]];

	if (![user isEqualToString:@"root"] && ![user isEqualToString:@"mobile"]) {
		return JBSPWStatusInvalidUser;
	}

	NSError *contentErr = nil;

	NSString *contents = [NSString stringWithContentsOfFile:@"/etc/master.passwd" encoding:NSUTF8StringEncoding error:&contentErr];

	if (contentErr) {
		return JBSPWStatusCouldNotReadFile;
	}

	NSMutableArray *lines = [NSMutableArray arrayWithArray:[contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]];

	BOOL foundUser = NO;
	BOOL validFormat = YES;
	BOOL setNewPass = NO;

	for (int i = 0; i < lines.count; i++) {
		NSString *line = lines[i];

		if ([line hasPrefix:user]) {
			foundUser = YES;

			NSMutableArray *lineComponents = [NSMutableArray arrayWithArray:[line componentsSeparatedByString:@":"]];

			if (lineComponents.count == 10) {
				NSArray<NSString *> *characterSet = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @".", @"/"];

				NSString *firstRandomChar = characterSet[arc4random() % characterSet.count];
				NSString *secondRandomChar = characterSet[arc4random() % characterSet.count];
				NSString *salt = [NSString stringWithFormat:@"%@%@", firstRandomChar, secondRandomChar];

				char *newPass = crypt([pass UTF8String], [salt UTF8String]);

				if (newPass) {
					NSString *newPassString = [NSString stringWithUTF8String:newPass];

					lineComponents[1] = newPassString;

					lines[i] = [lineComponents componentsJoinedByString:@":"];

					setNewPass = YES;
				}
			} else {
				validFormat = NO;
			}

			break;
		}
	}

	if (!foundUser) {
		return JBSPWStatusCouldNotFindUser;
	}

	if (!validFormat) {
		return JBSPWStatusInvalidFileFormat;
	}

	if (!setNewPass) {
		return JBSPWStatusFailedToEncrypt;
	}

	NSError *writeError = nil;

	[[lines componentsJoinedByString:@"\n"] writeToFile:@"/etc/master.passwd" atomically:YES encoding:NSUTF8StringEncoding error:&writeError];

	if (writeError) {
		return JBSPWStatusCouldNotWritePassword;
	}

	return 0;
}

// vim:ft=objc
