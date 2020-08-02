import 'package:flutter/material.dart';
import 'package:hotu_module/model/user_info.dart';
import 'package:hotu_module/utils/color_set.dart';
import 'package:hotu_module/utils/http_helper.dart';
import 'package:hotu_module/widget/fy_app_bar.dart';
import 'package:hotu_module/widget/fy_scaffold.dart';
import 'package:hotu_module/widget/fy_web_view_page.dart';
import 'package:hotu_module/widget/fy_widgets.dart';
import 'package:toast/toast.dart';

class CertiFicationPage extends StatelessWidget {
  var name = UserInfo.instance.name;

  var idNo = UserInfo.instance.idNo;

  @override
  Widget build(BuildContext context) {
    return FYScaffold(
      appBar: FYAppBar(
        title: "实名认证",
        actions: <Widget>[
          IconButton(
            icon: Text("提交"),
            onPressed: () {
              _httpVertifiyRealName(context);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          FYTextFieldRow(
            hintText: "请输入真实姓名",
            text: UserInfo.instance.name,
            onTextChanged: (text) {
              name = text;
            },
          ),
          FYTextFieldRow(
            hintText: "请输入身份证号码",
            text: UserInfo.instance.idNo,
            onTextChanged: (text) {
              idNo = text;
            },
          ),
          Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(child: Container()),
                Text(
                  "提交即表示同意",
                  style: TextStyle(
                    color: ColorSet.hintColor,
                    fontSize: 12,
                  ),
                ),
                InkWell(
                  child: Text(
                    "用户协议",
                    style: TextStyle(
                      color: ColorSet.orangeText,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    final String url =
                        "http://www.hotu.club:9595/agreement/agreementhz.html";
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FYWebViewPage(
                              url,
                              title: "用户协议",
                            )));
                  },
                ),
                InkWell(
                  child: Text(
                    "及隐私条款",
                    style: TextStyle(
                      color: ColorSet.orangeText,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () async {
                    final String url =
                        "http://www.hotu.club:9595/agreement/agreement.html";
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FYWebViewPage(
                              url,
                              title: "隐私协议",
                            )));
                  },
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _httpVertifiyRealName(BuildContext context) async {
    if (name.isEmpty) {
      Toast.show("请输入真实姓名", context);
      return;
    }
    if (idNo.isEmpty) {
      Toast.show("请输入身份证号", context);
      return;
    }
    Map<String, String> params = {"idNo": idNo, "name": name};
    Map data = await HttpHelper().post("user/savedIdNo", params: params);
    if (data["code"] != "200") {
      return;
    }
    Toast.show("认证成功", context);
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(true);
    });
  }
}
