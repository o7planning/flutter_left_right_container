part of '../../left_right_container.dart';

class _SizeMeasureWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeMeasured;

  const _SizeMeasureWidget({
    required this.onSizeMeasured,
    required this.child,
  });

  @override
  State<_SizeMeasureWidget> createState() => _SizeMeasureWidgetState();
}

class _SizeMeasureWidgetState extends State<_SizeMeasureWidget> {
  final GlobalKey _sizeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _sizeKey,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getSize();
    });
  }

  void _getSize() {
    RenderBox renderBox =
        _sizeKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    widget.onSizeMeasured(size);
  }
}
