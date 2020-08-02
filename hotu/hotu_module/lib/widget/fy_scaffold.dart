import 'package:flutter/material.dart';
import 'package:hotu_module/utils/color_set.dart';
import 'package:hotu_module/utils/config.dart';
import 'package:hotu_module/widget/fy_app_bar.dart';

class FYScaffold<T> extends StatelessWidget {
  final Widget body;

  final FYAppBar appBar;

  final Color backgroundColor;

  final Future<Map> future;

  final Function(T) dataControl;

  T data;

  FYScaffold(
      {this.backgroundColor = ColorSet.bgColor,
      this.appBar,
      this.body,
      this.future,
      this.dataControl})
      : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: Container(
        padding: EdgeInsets.only(bottom: Config.instance.bottomHeight, top: 1),
        child: _renderFutureBuilder(),
      ),
    );
  }

  FutureBuilder _renderFutureBuilder() {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return body;
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.done:
            if (!snapshot.hasError &&
                snapshot.hasData &&
                snapshot.data["code"] == "200") {
              if (snapshot.data["data"] != null) {
                data = snapshot.data["data"];
                dataControl?.call(data);
                return body;
              } else {
                return Container(
                  child: Center(
                    child: Text("error"),
                  ),
                );
              }
            }
            return Container(
              child: Center(
                child: Text("error"),
              ),
            );
          default:
            return Container();
        }
      },
    );
  }
}
