import 'package:flutter/material.dart';
import 'package:hotu_module/utils/http_helper.dart';
import 'package:hotu_module/widget/fy_focus.dart';
import 'package:toast/toast.dart';
import '../widget/fy_app_bar.dart';
import '../widget/fy_scaffold.dart';

class ReportPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FYScaffold(
      appBar: FYAppBar(
        title: "举报",
        actions: <Widget>[
          IconButton(
            icon: Text("提交"),
            onPressed: () {
              _httpReport(context);
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 15, right: 15),
        height: 185,
        color: Colors.white,
        child: FocusWidget(
          focusNode: _focusNode,
          child: TextField(
            focusNode: _focusNode,
            controller: _controller,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration:
                InputDecoration(hintText: "请填写举报内容", border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  _httpReport(BuildContext context) async {
    if (_controller.text.isEmpty) {
      Toast.show("请输入举报内容", context);
      return;
    }
    Map<String, String> params = {"content": _controller.text};
    Map data = await HttpHelper().post("complain/addComplain", params: params);
    if (data["code"] != "200") {
      Toast.show(data["msg"], context);
    } else {
      Toast.show("举报成功", context);
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }
  }
}
