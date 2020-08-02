import 'package:flutter/material.dart';

class FYLoading extends StatefulWidget {
  final Widget body;

  final bool isShow;

  FYLoading({@required this.body, this.isShow = false}) : super();

  @override
  _FYLoadingState createState() => _FYLoadingState();
}

class _FYLoadingState extends State<FYLoading> {
  @override
  Widget build(BuildContext context) {
    List<Widget> list = List();
    if (widget.isShow) {
      list = [
        widget.body,
        Opacity(
          opacity: 0,
          child: ModalBarrier(
            color: Colors.black,
          ),
        ),
        Center(
          child: CircularProgressIndicator(),
        )
      ];
    } else {
      list = [widget.body];
    }
    return Stack(
      children: list,
    );
  }
}
