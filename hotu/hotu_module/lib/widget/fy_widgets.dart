import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hotu_module/utils/color_set.dart';
import 'package:hotu_module/utils/http_helper.dart';
import 'package:hotu_module/widget/fy_focus.dart';
import 'package:toast/toast.dart';

class FYListRow extends StatelessWidget {
  final String title;

  final String des;

  final bool isArrow;

  final Function() onTap;

  FYListRow(this.title, {this.des, this.isArrow = true, this.onTap}) : super();

  @override
  Widget build(BuildContext context) {
    var list = [
      Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text(title,
              style: TextStyle(color: Color(0xff333333), fontSize: 16)),
        ),
      ),
      Container(
        margin: EdgeInsets.only(right: 15),
        child: Text(des ?? "",
            textAlign: TextAlign.right,
            style: TextStyle(color: Color(0xff666666), fontSize: 16)),
      ),
    ];
    if (isArrow) {
      list.add(Icon(
        Icons.navigate_next,
        color: Colors.grey,
      ));
    }

    return Column(
      children: <Widget>[
        GestureDetector(
          child: Container(
            color: Colors.white,
            height: 69,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: list,
            ),
          ),
          onTap: onTap ?? () {},
        ),
        Container(
          height: 0.5,
          color: ColorSet.sepColor,
        )
      ],
    );
  }
}

class FYVertifyCodeRow extends StatefulWidget {
  final Function(String) onTextChanged;

  FYVertifyCodeRow({this.onTextChanged}) : super();

  @override
  _FYVertifyCodeRowState createState() => _FYVertifyCodeRowState();
}

class _FYVertifyCodeRowState extends State<FYVertifyCodeRow> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer _timer;
  int _second = 60;
  String _text = "获取验证码";
  bool _isEnable = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: FocusWidget(
                    focusNode: _focusNode,
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "输入手机号码",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: ColorSet.hintColor,
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                      onChanged: widget.onTextChanged,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                  width: 80,
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    color: ColorSet.btnColor,
                    textColor: Colors.white,
                    disabledTextColor: Colors.grey,
                    disabledColor: ColorSet.disableBtnColor,
                    onPressed: _isEnable ? _httpGetVertifyCode : null,
                    child: Text(
                      _text,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 0.5,
              color: ColorSet.sepColor,
            )
          ],
        ));
  }

  _countDown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var a = _second - timer.tick;
      if (a > 0) {
        setState(() {
          _text = "${a}s后重试";
          _isEnable = false;
        });
      } else {
        setState(() {
          _text = "获取验证码";
          _isEnable = true;
        });
        _timer.cancel();
        _timer = null;
      }
    });
  }

  _httpGetVertifyCode() async {
    if (_textController.text.isEmpty) {
      Toast.show("请输入手机号码", context);
      return;
    }
    Map<String, String> params = {"phone_no": _textController.text};
    Map data = await HttpHelper().post("user/sendValidCode", params: params);
    if (data["code"] != "200") {
      Toast.show("发送失败", context);
    } else {
      Toast.show("发送成功", context);
      _countDown();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }
}

class FYTextFieldRow extends StatelessWidget {
  final String hintText;
  final bool isArrow;
  final String text;
  final Function(String) onTextChanged;

  FYTextFieldRow(
      {this.text = "",
      this.hintText = "",
      this.isArrow = false,
      this.onTextChanged})
      : super();

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _controller.text = text;
    List<Widget> list = [
      Expanded(
        child: FocusWidget(
          focusNode: _focusNode,
          child: TextField(
            focusNode: _focusNode,
            controller: _controller,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: ColorSet.hintColor,
                ),
                border: InputBorder.none),
            style: TextStyle(fontSize: 16),
            onChanged: onTextChanged,
          ),
        ),
      ),
    ];
    if (isArrow) {
      list.add(Icon(
        Icons.navigate_next,
        color: Colors.grey,
      ));
    }
    return Container(
      color: Colors.white,
      height: 69,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(children: list),
          ),
          Container(
            height: 0.5,
            color: ColorSet.sepColor,
          )
        ],
      ),
    );
  }
}
