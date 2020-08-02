import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotu_module/utils/color_set.dart';
import 'package:hotu_module/utils/http_helper.dart';
import 'package:hotu_module/widget/fy_app_bar.dart';
import 'package:hotu_module/widget/fy_scaffold.dart';

class PrivatePage extends StatefulWidget {
  @override
  _PrivatePageState createState() => _PrivatePageState();
}

class _PrivatePageState extends State<PrivatePage> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return FYScaffold(
        appBar: FYAppBar(
          title: "隐私设置",
        ),
        future: HttpHelper().post("userSetUp/getUserSetUp"),
        dataControl: (data) {
          isCheck = data["isAcceptMailList"].toString() == "1";
        },
        body: Builder(
          builder: (context) => Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15),
            height: 69,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "允许访问我的通讯录",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                CupertinoSwitch(
                  value: isCheck,
                  onChanged: (v) {
                    _httpSetSwitchStatus();
                  },
                  activeColor: ColorSet.btnColor,
                )
              ],
            ),
          ),
        ));
  }

  _httpSetSwitchStatus() async {
    String value = isCheck ? "0" : "1";
    Map<String, String> params = {"isAcceptMailList": value};
    print(params);
    Map data =
        await HttpHelper().post("userSetUp/updateByUserId", params: params);
    if (data["code"] != "200") {
      return;
    }
    setState(() {
      isCheck = !isCheck;
    });
  }
}
