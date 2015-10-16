#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();

captureLocalizedScreenshot("Today")

target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_PORTRAIT);
target.frontMostApp().tabBar().buttons()["Forecast"].tap();

// target.delay(1)
captureLocalizedScreenshot("Forecast")