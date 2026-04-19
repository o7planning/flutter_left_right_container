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
    //
    _showStart =
        !widget.initiallyCollapsed || widget.fixedSide == FixedSide.end;
    _showEnd =
        !widget.initiallyCollapsed || widget.fixedSide == FixedSide.start;
  }

  @override
  Widget build(BuildContext context) {
    final Color globalBg =
        widget.style.backgroundColor ?? FaColorUtils.background(context);
    final Color startBg =
        widget.style.startBackgroundColor ?? Colors.transparent;
    final Color endBg = widget.style.endBackgroundColor ?? Colors.transparent;
    final Color dividerColor = FaColorUtils.dividerColor(context);

    final Color arrowBg =
        widget.style.arrowButtonBackgroundColor ??
        FaColorUtils.surfaceContainerHighest(context).withValues(alpha: 0.8);
    final Color arrowIconColor =
        widget.style.arrowIconColor ?? FaColorUtils.primaryHighlight(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth;
        final minTwoSideWidth =
            widget.fixedSizeWidth + widget.spacing + widget.minSideWidth;

        if (!_collapsedByUser && widget.autoShowTwoSidesIfPossible) {
          if (contentWidth >= minTwoSideWidth) {
            _showStart = true;
            _showEnd = true;
          } else if (_showStart && _showEnd) {
            _showStart = (widget.fixedSide == FixedSide.end);
            _showEnd = (widget.fixedSide == FixedSide.start);
          }
        }

        return Container(
          color: globalBg,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showStart)
                    _buildPanel(
                      child: widget.start,
                      width:
                          (_showStart &&
                              _showEnd &&
                              widget.fixedSide == FixedSide.start)
                          ? widget.fixedSizeWidth
                          : null,
                      color: startBg,
                      padding: widget.style.startPadding,
                    ),

                  if (_showStart && _showEnd) ...[
                    if (widget.showVerticalDivider)
                      VerticalDivider(
                        width: widget.spacing,
                        thickness: 1,
                        color: dividerColor,
                      ),
                    if (!widget.showVerticalDivider)
                      SizedBox(width: widget.spacing),
                  ],

                  if (_showEnd)
                    _buildPanel(
                      child: widget.end,
                      width:
                          (_showStart &&
                              _showEnd &&
                              widget.fixedSide == FixedSide.end)
                          ? widget.fixedSizeWidth
                          : null,
                      color: endBg,
                      padding: widget.style.endPadding,
                    ),
                ],
              ),

              // 4. ARROW TOGGLE BUTTON
              if (!(widget.hideArrowIfTwoSidesVisible &&
                  _showStart &&
                  _showEnd))
                _buildArrowButton(
                  contentWidth: contentWidth,
                  minTwoSideWidth: minTwoSideWidth,
                  backgroundColor: arrowBg,
                  iconColor: arrowIconColor,
                  dividerColor: dividerColor,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPanel({
    required Widget child,
    double? width,
    Color? color,
    required EdgeInsets padding,
  }) {
    Widget content = Container(color: color, padding: padding, child: child);

    return width != null
        ? SizedBox(width: width, child: content)
        : Expanded(child: content);
  }

  Widget _buildArrowButton({
    required double contentWidth,
    required double minTwoSideWidth,
    required Color backgroundColor,
    required Color iconColor,
    required Color dividerColor,
  }) {
    double arrowLeft;
    IconData iconData;

    if (_showStart && _showEnd) {
      arrowLeft = (widget.fixedSide == FixedSide.start)
          ? (widget.fixedSizeWidth +
                widget.spacing / 2 -
                widget.style.arrowWidth / 2)
          : (contentWidth -
                widget.fixedSizeWidth -
                widget.spacing / 2 -
                widget.style.arrowWidth / 2);
    } else {
      arrowLeft = _showStart ? (contentWidth - widget.style.arrowWidth) : 0;
    }

    if (_showStart && _showEnd) {
      iconData = (widget.fixedSide == FixedSide.start)
          ? Icons.chevron_left_rounded
          : Icons.chevron_right_rounded;
    } else {
      iconData = (arrowLeft == 0)
          ? Icons.chevron_right_rounded
          : Icons.chevron_left_rounded;
    }

    return Positioned(
      top: widget.arrowTopPosition,
      left: arrowLeft,
      child: GestureDetector(
        onTap: () => setState(() {
          if (contentWidth < minTwoSideWidth) {
            _showStart = !_showStart;
            _showEnd = !_showEnd;
          } else {
            if (widget.fixedSide == FixedSide.start) {
              _showStart = !_showStart;
            } else {
              _showEnd = !_showEnd;
            }
            _collapsedByUser = !(_showStart && _showEnd);
          }
        }),
        child: Container(
          width: widget.style.arrowWidth,
          height: widget.style.arrowHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius:
                widget.style.arrowBorderRadius ?? BorderRadius.circular(4),
            border: Border.all(color: dividerColor.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(iconData, size: 18, color: iconColor),
        ),
      ),
    );
  }
}
