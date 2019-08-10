ARCHS = arm64 arm64e
TARGET = iphone::11.0

include $(THEOS)/makefiles/common.mk

TOOL_NAME = jbstouch
jbstouch_FILES = main.mm
jbstouch_CODESIGN_FLAGS = -Sent.xml

ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tool.mk
