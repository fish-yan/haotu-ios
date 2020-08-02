import 'package:flutter/material.dart';
import 'package:hotu_module/widget/fy_scaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'fy_app_bar.dart';

class FYWebViewPage extends StatefulWidget {
  final String title;

  final String url;

  FYWebViewPage(this.url, {this.title = ""}) : super();

  @override
  _FYWebViewPageState createState() => _FYWebViewPageState();
}

class _FYWebViewPageState extends State<FYWebViewPage> {
  WebViewController _controller;

  String _tit = "";
  @override
  Widget build(BuildContext context) {
    if (widget.title.isNotEmpty) {
      _tit = widget.title;
    }
    return FYScaffold(
      appBar: FYAppBar(
        title: _tit,
      ),
      body: Builder(
        builder: (context) {
          return WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _controller = controller;
            },
            onPageFinished: (url) {
              _controller.evaluateJavascript("document.title").then((value) {
                if (widget.title.isEmpty) {
                  setState(() {
                    _tit = value;
                  });
                }
              });
            },
          );
        },
      ),
    );
  }
}
