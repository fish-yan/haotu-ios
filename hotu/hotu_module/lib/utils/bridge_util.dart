
import 'native_bridge.dart' if (dart.library.html) 'web_bridge.dart' as bridge;

const String Android = "Android";

const String IOS = "IOS";

const String WebAndroid = "WebAndroid";

const String WebIOS = "WebIOS";

const String WebOther = "WebOther";

bool isWeb = identical(0, 0.0);

String getUrl() {
  return bridge.Bridge.instance.getUrl();
}

Map<String, String> getUrlParams() {
  return bridge.Bridge.instance.getUrlParams();
}

String getPlatform() {
  return bridge.Bridge.instance.getPlatform();
}

double getStatusBarHeight() {
  return bridge.Bridge.instance.getStatusBarHeight();
}

double getBottomHeight() {
  return bridge.Bridge.instance.getBottomHeight();
}

addGobackListener() {
  bridge.Bridge.instance.addGobackListener();
}

callCloseWebView() {
  bridge.Bridge.instance.callCloseWebView();
}

wxShare(String json) {
  bridge.Bridge.instance.wxShare(json);
}
sharePost(String jsonStr) {
  bridge.Bridge.instance.sharePost(jsonStr);
}
