ARCHS = arm64 arm64e
TARGET = iphone::11.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = jbsetuppreferences
jbsetuppreferences_FILES = JBSRootListController.m ../JBSCustomNavigationController.m ../JBSCompletedViewController.m ../JBSSetupViewController.m ../JBSPasswordViewController.m ../JBSContinueButton.m ../JBSLoadingViewController.m ../JBSWelcomeViewController.m ../JBSPasswordManager.m ../JBSDummyViewController.m
jbsetuppreferences_INSTALL_PATH = /Library/PreferenceBundles
jbsetuppreferences_FRAMEWORKS = UIKit
jbsetuppreferences_PRIVATE_FRAMEWORKS = Preferences

ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/jbsetuppreferences.plist$(ECHO_END)
