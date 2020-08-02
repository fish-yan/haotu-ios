import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotu_module/main.dart';
import 'package:hotu_module/pages/report_page.dart';
import 'package:hotu_module/utils/color_set.dart';
import 'package:hotu_module/widget/fy_app_bar.dart';
import 'package:hotu_module/widget/fy_scaffold.dart';
import 'package:hotu_module/widget/fy_widgets.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = "";

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return FYScaffold(
      appBar: FYAppBar(
        title: "关于好兔",
      ),
      body: Container(
        color: ColorSet.bgColor,
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            FYListRow(
              "版本",
              des: _version,
              isArrow: false,
            ),
            FYListRow(
              "举报",
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ReportPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  _getVersion() async {
    try {
      String result = await MyApp.platform.invokeMethod("getVersion");
      setState(() {
        _version = result;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
