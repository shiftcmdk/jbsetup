ARCHS = arm64 arm64e
TARGET = iphone::11.0

include $(THEOS)/makefiles/common.mk

TOOL_NAME = jbspw
jbspw_FILES = main.mm
jbspw_CODESIGN_FLAGS = -Sent.xml

ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tool.mk
