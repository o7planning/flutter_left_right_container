part of '../../left_right_container.dart';

class LeftRightContainer extends StatefulWidget {
  final Widget start;
  final Widget end;
  final double fixedSizeWidth;
  final double minSideWidth;
  final FixedSide fixedSide;
  final double spacing;
  final double arrowTopPosition;
  final bool initiallyCollapsed;
  final bool autoShowTwoSidesIfPossible;
  final bool hideArrowIfTwoSidesVisible;
  final bool showVerticalDivider;
  final LeftRightContainerStyle style;

  const LeftRightContainer({
    super.key,
    required this.start,
    required this.end,
    required this.fixedSizeWidth,
    required this.minSideWidth,
    this.fixedSide = FixedSide.start,
    this.spacing = 0,
    this.arrowTopPosition = 50,
    this.initiallyCollapsed = false,
    this.autoShowTwoSidesIfPossible = true,
    this.hideArrowIfTwoSidesVisible = false,
    this.showVerticalDivider = true,
    this.style = const LeftRightContainerStyle(),
  });

  @override
  State<LeftRightContainer> createState() => _LeftRightContainerState();
}

class _LeftRightContainerState extends State<LeftRightContainer> {
  late bool _showStart;
  late bool _showEnd;
  bool _collapsedByUser = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo trạng thái đóng mở ban đầu
    _showStart = !widget.initiallyCollapsed || widget.fixedSide == FixedSide.end;
    _showEnd = !widget.initiallyCollapsed || widget.fixedSide == FixedSide.start;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth;
        final minTwoSideWidth = widget.fixedSizeWidth + widget.spacing + widget.minSideWidth;

        // 1. Logic tự động hiển thị (Gọn gàng hơn)
        if (!_collapsedByUser && widget.autoShowTwoSidesIfPossible) {
          if (contentWidth >= minTwoSideWidth) {
            _showStart = true;
            _showEnd = true;
          } else if (_showStart && _showEnd) {
            // Nếu không đủ chỗ mà đang hiện cả 2, thì thu gọn bên không cố định
            _showStart = (widget.fixedSide == FixedSide.end);
            _showEnd = (widget.fixedSide == FixedSide.start);
          }
        }

        return Container(
          color: widget.style.backgroundColor,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 2. Main Content dùng Row/Expanded (Bản sắc của ông)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showStart) _buildPanel(
                    child: widget.start,
                    width: (_showStart && _showEnd && widget.fixedSide == FixedSide.start) ? widget.fixedSizeWidth : null,
                    color: widget.style.startBackgroundColor,
                    padding: widget.style.startPadding,
                  ),

                  if (_showStart && _showEnd) ...[
                    if (widget.showVerticalDivider) VerticalDivider(width: widget.spacing, thickness: 1),
                    if (!widget.showVerticalDivider) SizedBox(width: widget.spacing),
                  ],

                  if (_showEnd) _buildPanel(
                    child: widget.end,
                    width: (_showStart && _showEnd && widget.fixedSide == FixedSide.end) ? widget.fixedSizeWidth : null,
                    color: widget.style.endBackgroundColor,
                    padding: widget.style.endPadding,
                  ),
                ],
              ),

              // 3. Arrow Toggle
              if (!(widget.hideArrowIfTwoSidesVisible && _showStart && _showEnd))
                _buildArrowButton(contentWidth, minTwoSideWidth),
            ],
          ),
        );
      },
    );
  }

  // Widget dựng Panel chung để loại bỏ if-else lặp lại
  Widget _buildPanel({required Widget child, double? width, Color? color, required EdgeInsets padding}) {
    Widget content = Container(
      color: color,
      padding: padding,
      child: child,
    );

    return width != null
        ? SizedBox(width: width, child: content)
        : Expanded(child: content);
  }

  Widget _buildArrowButton(double contentWidth, double minTwoSideWidth) {
    // Tính toán vị trí đơn giản không dùng AnimatedPositioned
    double arrowLeft;
    if (_showStart && _showEnd) {
      arrowLeft = (widget.fixedSide == FixedSide.start)
          ? (widget.fixedSizeWidth + widget.spacing / 2 - widget.style.arrowWidth / 2)
          : (contentWidth - widget.fixedSizeWidth - widget.spacing / 2 - widget.style.arrowWidth / 2);
    } else {
      arrowLeft = _showStart ? (contentWidth - widget.style.arrowWidth) : 0;
    }

    return Positioned(
      top: widget.arrowTopPosition,
      left: arrowLeft,
      child: GestureDetector(
        onTap: () => setState(() {
          if (contentWidth < minTwoSideWidth) {
            _showStart = !_showStart; _showEnd = !_showEnd;
          } else {
            if (widget.fixedSide == FixedSide.start) _showStart = !_showStart;
            else _showEnd = !_showEnd;
            _collapsedByUser = !(_showStart && _showEnd);
          }
        }),
        child: Container(
          width: widget.style.arrowWidth,
          height: widget.style.arrowHeight,
          decoration: BoxDecoration(
            color: widget.style.arrowButtonBackgroundColor,
            borderRadius: widget.style.arrowBorderRadius ?? BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Icon(
            _showStart ? Icons.chevron_left : Icons.chevron_right,
            size: 14,
            color: widget.style.arrowIconColor,
          ),
        ),
      ),
    );
  }
}