include theos/makefiles/common.mk

BUNDLE_NAME = VeloxStopwatch
VeloxStopwatch_FILES = VeloxStopwatchFolderView.mm
VeloxStopwatch_INSTALL_PATH = /Library/Velox/Plugins/
VeloxStopwatch_FRAMEWORKS = Foundation UIKit

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"