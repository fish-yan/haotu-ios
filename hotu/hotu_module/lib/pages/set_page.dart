import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotu_module/main.dart';
import 'package:hotu_module/pages/about_page.dart';
import 'package:hotu_module/pages/account_page.dart';
import 'package:hotu_module/pages/private_page.dart';
import 'package:hotu_module/utils/color_set.dart';
import 'package:hotu_module/widget/fy_app_bar.dart';
import 'package:hotu_module/widget/fy_scaffold.dart';
import 'package:hotu_module/widget/fy_widgets.dart';

class SetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FYScaffold(
      appBar: FYAppBar(
        title: "设置",
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () async {
            try {
              await MyApp.platform.invokeMethod('closeFlutter');
            } on PlatformException catch (e) {}
          },
        ),
      ),
      body: Container(
        color: ColorSet.bgColor,
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            FYListRow(
              "隐私设置",
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PrivatePage()));
              },
            ),
            FYListRow(
              "账号与安全",
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AccountPage()));
              },
            ),
            FYListRow(
              "关于好兔",
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AboutPage()));
              },
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(bottom: 100),
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                child: Container(
                  width: 88,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    "退出登录",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: ColorSet.btnColor,
                onPressed: () {
                  try {
                    MyApp.platform.invokeMethod("loginout");
                  } on PlatformException catch (e) {}
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
