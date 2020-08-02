import 'package:flutter/material.dart';

typedef FocusNodeBuilder = Widget Function(
    BuildContext context, FocusNode focusNode);

class FocusWidget extends StatefulWidget {
  final FocusNode focusNode;
  final Widget child;
  final Function(bool) onFocusChanged;

  const FocusWidget({
    Key key,
    this.focusNode,
    this.child,
    this.onFocusChanged,
  })  : assert(child != null && focusNode != null),
        super(key: key);

  @override
  FocusWidgetState createState() => FocusWidgetState();

  static FocusWidget builder(BuildContext context, FocusNodeBuilder builder) {
    final focusNode = FocusNode();
    return FocusWidget(
      focusNode: focusNode,
      child: builder(
        context,
        focusNode,
      ),
    );
  }
}

class FocusWidgetState extends State<FocusWidget> {
  OverlayEntry _overlayEntry;
  Offset topLeft, bottomRight;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusEvent);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusEvent);
    super.dispose();
  }

  void update() {
    if (!widget.focusNode.hasFocus) return;
    final RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;
    topLeft = renderBox.localToGlobal(Offset.zero);
    bottomRight = topLeft + Offset(size.width, size.height);
  }

  void _focusEvent() {
    if (widget.focusNode.hasFocus) {
      update();
      _overlayEntry = new OverlayEntry(
        builder: (context) {
          return Stack(
            children: [
              Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (PointerDownEvent e) {
                  final overX = e.position.dx <= topLeft.dx - 10 ||
                      e.position.dx >= bottomRight.dx + 10;
                  final overY = e.position.dy <= topLeft.dy - 10 ||
                      e.position.dy >= bottomRight.dy + 10;
                  if (overX || overY) {
                    widget.focusNode?.unfocus();
                  }
                },
              ),
            ],
          );
        },
      );
      Overlay.of(context).insert(_overlayEntry);
    } else {
      _overlayEntry?.remove();
    }
    if (widget.onFocusChanged != null) {
      widget.onFocusChanged(widget.focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}