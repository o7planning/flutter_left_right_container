part of '../../flutter_left_right_container.dart';

/// An auxiliary internal structural helper utility widget built to parse and trap
/// concrete pixel dimension bounds immediately post frame paint processing ticks.
class _SizeMeasureWidget extends StatefulWidget {
  /// The inner child asset whose concrete operational box size dimensions are requested.
  final Widget child;

  /// The functional target callback dishing the resolved geometric [Size] metrics back up into parent managers.
  final ValueChanged<Size> onSizeMeasured;

  /// Constructs a pure [_SizeMeasureWidget] interceptor asset.
  const _SizeMeasureWidget({required this.onSizeMeasured, required this.child});

  @override
  State<_SizeMeasureWidget> createState() => _SizeMeasureWidgetState();
}

/// Driven structural logic execution segment backing the active GlobalKey bounding box inspector.
class _SizeMeasureWidgetState extends State<_SizeMeasureWidget> {
  /// The global tracking identity blueprint assigned over the layout container framework pass.
  final GlobalKey _sizeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(key: _sizeKey, child: widget.child);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getSize();
    });
  }

  /// Triggers a low-level RenderBox identity look-up pass to safely pull exact pixel coordinates.
  void _getSize() {
    final context = _sizeKey.currentContext;
    if (context == null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    widget.onSizeMeasured(renderBox.size);
  }
}
