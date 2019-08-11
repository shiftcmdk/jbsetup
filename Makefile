ARCHS = arm64 arm64e
TARGET = iphone::11.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = jbsetup
jbsetup_FILES = Tweak.xm JBSCompletedViewController.m JBSContinueButton.m JBSLoadingViewController.m JBSPasswordViewController.m JBSSetupViewController.m JBSWelcomeViewController.m JBSPasswordManager.m JBSCustomNavigationController.m JBSDummyViewController.m

ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += jbspw
SUBPROJECTS += jbstouch
SUBPROJECTS += jbsetuppreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
