@JS()
library JSHelper;

import 'dart:html';
import 'dart:js_util' as jsUtil;
import 'dart:math';
import 'bridge_util.dart';
import "package:js/js.dart";
import 'config.dart';

class Bridge {
  static Bridge instance = Bridge();

  var bridge;

  bool checkBridge() {
    if (bridge == null) {
      jsUtil.setProperty(window, "android", Object());
      bridge = jsUtil.getProperty(window, "android");
    }
    return bridge != null;
  }

  void registerBridge(String name, void Function(String) callback) {
    if (checkBridge()) {
      jsUtil.setProperty(bridge, name, allowInterop(callback));
    }
  }

  String getPlatform() {
    var agent = window.navigator.userAgent;
    if (agent.contains("Android") || agent.contains("android")) {
      return WebAndroid;
    } else if (agent.contains("iPhone") || agent.contains("iphone")) {
      return WebIOS;
    } else {
      return WebOther;
    }
  }

  String getUrl() {
    String url = window.location.href;
    if (url.endsWith("#/")) {
      var lastIndex = url.lastIndexOf("#/");
      url = url.replaceFirst("#/", "", lastIndex);
    }
    return url.split("?").first;
  }

  Map<String, String> getUrlParams() {
    String url = window.location.href;
    if (url.endsWith("#/")) {
      var lastIndex = url.lastIndexOf("#/");
      url = url.replaceFirst("#/", "", lastIndex);
    }
    var uri = Uri.dataFromString(url);
    var params = uri.queryParameters;
    return params;
  }

  double getStatusBarHeight() {
    var h = 0;
    if (Config.instance.platform == WebAndroid) {
      if ((window.screen.height - 1) / window.screen.width > 16 / 9) {
        //刘海屏
        h = min((window.screen.height - window.innerHeight), 40);
      }
    } else if (Config.instance.platform == WebIOS) {
      if ((window.screen.height - 1) / window.screen.width > 16 / 9) {
        //刘海屏
        h = 40;
      }
    }
    h = max(h, 20);
    return h.toDouble();
  }

  double getBottomHeight() {
    var h = 0;
    if ((window.screen.height - 1) / window.screen.width > 16 / 9) {
      //刘海屏
      h = 20;
    }
    return h.toDouble();
  }

  addGobackListener() {
    window.addEventListener("popstate", (event) {  
      if (Config.instance.isHome) {
        callCloseWebView();
      }
      if (window.history.length <= 2 && !Config.instance.isHome) {
        Config.instance.isHome = true;
      } else {
        Config.instance.isHome = false;
      }    
    });
  }

  callCloseWebView() {
    if (getPlatform() == WebAndroid) {
      callAndroidCloseWebview();
    } else if (getPlatform() == WebIOS) {
      callIOSCloseWebview();
    }
  }

  wxShare(String jsonStr) {
    if (getPlatform() == WebAndroid) {
      wxAndroidShare(jsonStr);
    } else if (getPlatform() == WebIOS) {
      wxIOSShare(jsonStr);
    }
  }

  sharePost(String jsonStr) {
    if (getPlatform() == WebAndroid) {
      androidSharePost(jsonStr);
    } else if (getPlatform() == WebIOS) {
      iosSharePost(jsonStr);
    }
  }
}

//dart 调用iOS

@JS("callCloseWebview")
external callIOSCloseWebview();

@JS("doWechatShare")
external wxIOSShare(jsonStr);

@JS("sharePost")
external iosSharePost(jsonStr);

//dart调用Android

@JS("window.android.callCloseWebview")
external callAndroidCloseWebview();

@JS("window.android.doWechatShare")
external wxAndroidShare(jsonStr);

@JS("window.android.sharePost")
external androidSharePost(jsonStr);

