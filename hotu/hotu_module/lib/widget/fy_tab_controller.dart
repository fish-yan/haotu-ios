import 'package:flutter/material.dart';
import 'dart:ui';

typedef FYTapCallBack = Function(int);

class FYTabController extends StatefulWidget {
  final List<String> titles;

  final List<Widget> pages;

  FYTabController({this.titles, this.pages}) : super();

  @override
  _FYTabControllerState createState() => _FYTabControllerState();
}

class _FYTabControllerState extends State<FYTabController> {
  FYTabBar _tabBar;

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    PageController _controller = PageController();

    _tabBar = FYTabBar(
      titles: widget.titles,
      index: _currentPage,
      onTabChanged: (index) {
        _controller.animateToPage(index,
            duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
        _currentPage = index;
      },
    );
    return Column(
      children: <Widget>[
        _tabBar,
        Expanded(
          child: PageView(
            children: widget.pages,
            allowImplicitScrolling: false,
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
      ],
    );
  }
}

class FYTabBar extends StatelessWidget {
  final List<String> titles;

  final int index;

  final TextStyle defaultStyle;
  final TextStyle selectedStyle;

  final double indicatorWeight;
  final Color indicatorColor;

  final FYTapCallBack onTabChanged;

  FYTabBar({
    @required this.titles,
    this.defaultStyle,
    this.selectedStyle,
    @required this.index,
    this.indicatorColor,
    this.indicatorWeight,
    this.onTabChanged,
  }) : super();

  @override
  Widget build(BuildContext context) {
    var iColor = indicatorColor ?? Color(0xff00baff);
    var iWeight = indicatorWeight ?? 2;
    var a = (MediaQuery.of(context).size.width / titles.length);
    return Column(
      children: <Widget>[
        Container(
          height: 43,
          child: Row(
            children: _configTabs(),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: iWeight,
          child: Container(
            margin: EdgeInsets.only(
              left: a * index + (a - 112) / 2,
            ),
            height: 2,
            width: 112,
            color: iColor,
          ),
        ),
      ],
    );
  }

  _configTabs() {
    var dStyle =
        defaultStyle ?? TextStyle(color: Color(0xff333333), fontSize: 16);
    var sStyle =
        selectedStyle ?? TextStyle(color: Color(0xff00baff), fontSize: 16);
    List<FYTab> tabs = [];
    int i = 0;
    for (String text in titles) {
      TextStyle style = index == i ? sStyle : dStyle;
      FYTab t = FYTab(text, style: style, index: i, onTap: (index) {
        if (onTabChanged != null) {
          onTabChanged(index);
        }
      });
      tabs.add(t);
      i++;
    }
    return tabs;
  }

}

class FYTab extends StatelessWidget {
  final String text;

  final TextStyle style;

  final FYTapCallBack onTap;

  final int index;

  FYTab(this.text, {this.style, this.index, this.onTap}) : super();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text(text, style: style),
          ),
        ),
        onTap: () {
          onTap(index);
        },
      ),
    );
  }
}
