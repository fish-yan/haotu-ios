import 'package:flutter/material.dart';
import 'package:hotu_module/utils/config.dart';

class FYAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  final Widget leading;

  final List<Widget> actions;

  final Color backgroundColor;

  FYAppBar(
      {this.title = "",
      this.leading,
      this.actions,
      this.backgroundColor = Colors.white})
      : super();

  @override
  _FYAppBarState createState() => _FYAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(44 + Config.instance.statusBarHeight);
}

class _FYAppBarState extends State<FYAppBar> {
  @override
  Widget build(BuildContext context) {
    Widget l = IconButton(
      icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    if (widget.leading != null) {
      l = widget.leading;
    }
    return Container(
      color: widget.backgroundColor,
      padding: EdgeInsets.only(top: Config.instance.statusBarHeight),
      child: Container(
        height: 44,
        child: Row(
        children: <Widget>[
          Container(
            width: 60,
            child: l,
          ),
          Expanded(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: 60,
            child: widget.actions == null ? null : Row(
              children: widget.actions,
            ),
          )
        ],
      ),
      )
    );
  }
}
