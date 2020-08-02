import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotu_module/model/user_info.dart';
import 'package:hotu_module/pages/set_page.dart';
import 'package:hotu_module/utils/config.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  static const platform = const MethodChannel("hotu.modul.channel");

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Config.initConfig();
    _configChannel();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerTriggerDistance: 56,
      child: materialApp(),
    );
  }

  Widget materialApp() {
    return MaterialApp(
      title: "好兔",
      theme:
          ThemeData(primaryColor: Colors.white, brightness: Brightness.light),
      home: SetPage(),
    );
  }

  _configChannel() {
    UserInfo.instance.tokenId = "c2f05e7623734f07b79fe0c043e64162";
    MyApp.platform.setMethodCallHandler((call) async {
      switch (call.method) {
        case "statusBarHeight":
          Config.instance.statusBarHeight = call.arguments;
          setState(() {});
          break;
        case "setTokenId":
          UserInfo.instance.tokenId = call.arguments;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("tokenId", UserInfo.instance.tokenId);
          break;
        case "isDebug":
          Config.instance.debug = call.arguments == 0;
          print("isDebug = ${Config.instance.debug}");
          break;
        default:
          break;
      }
      return null;
    });
  }
}
