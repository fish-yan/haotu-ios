
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

import 'bridge_util.dart';

class Bridge {
  static Bridge instance = Bridge();

  String getPlatform() {
    if (Platform.isAndroid) {
    return Android;
  } else if (Platform.isIOS) {
    return IOS;
  } else {
    return "other";
  }
  }

  String getUrl() {
    return "";
  }

  Map<String, String> getUrlParams() {
   return {"token_id":"202004100000112545","oper_no":"xueyan03"};
  }

  double getStatusBarHeight() {
    return  MediaQueryData.fromWindow(window).padding.top;
  }

  double getBottomHeight() {
   return MediaQueryData.fromWindow(window).padding.bottom;
  }

  addGobackListener() {
   
  }

  callCloseWebView() {

  }

  wxShare(String jsonStr) {

  }

  sharePost(String jsonStr) {

  }

}