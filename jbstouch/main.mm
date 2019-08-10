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

	setuid(0);
	setgid(0);

	char *cmd = strdup([@"touch" UTF8String]);
	char *args[3];
	args[0] = strdup([@"touch" UTF8String]);
	args[1] = strdup([@"/etc/master.passwd" UTF8String]);
	args[2] = NULL;

	int status = execvp(cmd, args);

	free(cmd);
	free(args[0]);
	free(args[1]);

	return status;
}

// vim:ft=objc
