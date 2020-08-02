import 'package:flutter/material.dart';
import 'package:hotu_module/utils/http_helper.dart';
import 'package:hotu_module/widget/fy_app_bar.dart';
import 'package:hotu_module/widget/fy_scaffold.dart';
import 'package:hotu_module/widget/fy_widgets.dart';
import 'package:toast/toast.dart';

class TelBindPage extends StatelessWidget {
  String _tel = "";
  String _code = "";
  @override
  Widget build(BuildContext context) {
    return FYScaffold(
      appBar: FYAppBar(
        title: "手机绑定",
        actions: <Widget>[
          IconButton(
            icon: Text("提交"),
            onPressed: () {
              _httpBindTel(context);
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            FYVertifyCodeRow(
              onTextChanged: (text) {
                _tel = text;
              },
            ),
            FYTextFieldRow(
              hintText: "请填写验证码",
              onTextChanged: (text) {
                _code = text;
              },
            ),
          ],
        ),
      ),
    );
  }

  _httpBindTel(BuildContext context) async {
    if (_tel.isEmpty) {
      Toast.show("请输入手机号", context);
      return;
    }
    if (_code.isEmpty) {
      Toast.show("请输入验证码", context);
      return;
    }
    Map<String, String> params = {"phoneNo":_tel,"validCode":_code};
    Map data = await HttpHelper().post("user/editUserInfo", params: params);
    if (data["code"] != "200") {
      Toast.show("绑定失败", context);
    } else {
      Toast.show("绑定成功", context);
      Navigator.of(context).pop(true);
    }

  }
}
