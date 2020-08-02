
import 'package:flutter/material.dart';
import 'package:hotu_module/model/user_info.dart';
import 'package:hotu_module/pages/certification_page.dart';
import 'package:hotu_module/pages/tel_bind_page.dart';
import 'package:hotu_module/utils/http_helper.dart';

import '../widget/fy_app_bar.dart';
import '../widget/fy_scaffold.dart';
import '../widget/fy_widgets.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  @override
  void initState() {
    super.initState();
    _httpGetUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FYScaffold(
      appBar: FYAppBar(
        title: "账号与安全",
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            FYListRow(
              "好兔账号",
              des: UserInfo.instance.id,
              isArrow: false,
            ),
            FYListRow(
              "手机绑定",
              des: UserInfo.instance.mblNo,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TelBindPage()));
              },
            ),
            FYListRow(
              "实名认证",
              des: UserInfo.instance.isRealName == "1" ? "已认证" : "未认证",
              onTap: () async {
                bool needRefresh = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CertiFicationPage()));
                if (needRefresh == true) {
                  _httpGetUserInfo();
                }
              },
            ),
          ],
        ),
      ),
    );
  }


  _httpGetUserInfo() async {
    Map data = await HttpHelper().post("user/queryUserInfoByUserId");
    if (data["code"] != "200") {
      return;
    }
    UserInfo info = UserInfo.fromeJson(data["data"]);
    info.setInstance();
    setState(() {
      
    });
  }
}
