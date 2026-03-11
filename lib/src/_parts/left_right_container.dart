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
  final TextDirection? textDirection;

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
    this.textDirection,
  });

  @override
  State<LeftRightContainer> createState() => _LeftRightContainerState();
}

class _LeftRightContainerState extends State<LeftRightContainer> {
  late bool _showStart;
  late bool _showEnd;
  bool _collapsedByUser = false;
  late TextDirection _dir;

  @override
  void initState() {
    super.initState();
    _showStart =
        !widget.initiallyCollapsed || widget.fixedSide == FixedSide.end;
    _showEnd =
        !widget.initiallyCollapsed || widget.fixedSide == FixedSide.start;
  }

  void _handleToggle(double contentWidth, double minTwoSideWidth) {
    setState(() {
      if (contentWidth < minTwoSideWidth) {
        _showStart = !_showStart;
        _showEnd = !_showEnd;
      } else {
        if (widget.fixedSide == FixedSide.start) {
          _showStart = !_showStart;
          _showEnd = true;
        } else {
          _showEnd = !_showEnd;
          _showStart = true;
        }
        _collapsedByUser = !(_showStart && _showEnd);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _dir = widget.textDirection ?? Directionality.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth;
        final minTwoSideWidth =
            widget.fixedSizeWidth + widget.spacing + widget.minSideWidth;

        if (!_collapsedByUser &&
            widget.autoShowTwoSidesIfPossible &&
            contentWidth >= minTwoSideWidth) {
          _showStart = true;
          _showEnd = true;
        } else if (contentWidth < minTwoSideWidth && _showStart && _showEnd) {
          if (widget.fixedSide == FixedSide.start) {
            _showStart = false;
            _showEnd = true;
          } else {
            _showStart = true;
            _showEnd = false;
          }
        }
        double startWidth = 0;
        double endWidth = 0;
        if (_showStart && _showEnd) {
          if (widget.fixedSide == FixedSide.start) {
            startWidth = widget.fixedSizeWidth;
            endWidth = contentWidth - widget.fixedSizeWidth - widget.spacing;
          } else {
            endWidth = widget.fixedSizeWidth;
            startWidth = contentWidth - widget.fixedSizeWidth - widget.spacing;
          }
        } else {
          startWidth = _showStart ? contentWidth : 0;
          endWidth = _showEnd ? contentWidth : 0;
        }

        final isLTR = _dir == TextDirection.ltr;

        return Container(
          color: widget.style.backgroundColor,
          child: Stack(
            children: [
              // 1. Start Panel (Background + Content)
              AnimatedPositioned(
                duration: widget.style.animationDuration,
                curve: widget.style.animationCurve,
                left: isLTR ? 0 : null,
                right: isLTR ? null : 0,
                top: 0,
                bottom: 0,
                width: startWidth,
                child: Container(
                  color: widget.style.startBackgroundColor,
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: isLTR ? Alignment.topLeft : Alignment.topRight,
                      minWidth: 0,
                      maxWidth: _showStart && _showEnd
                          ? startWidth
                          : contentWidth,
                      child: Padding(
                        padding: widget.style.startPadding,
                        child: widget.start,
                      ),
                    ),
                  ),
                ),
              ),

              // 2. End Panel (Background + Content)
              AnimatedPositioned(
                duration: widget.style.animationDuration,
                curve: widget.style.animationCurve,
                left: isLTR ? null : 0,
                right: isLTR ? 0 : null,
                top: 0,
                bottom: 0,
                width: endWidth,
                child: Container(
                  color: widget.style.endBackgroundColor,
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: isLTR ? Alignment.topRight : Alignment.topLeft,
                      minWidth: 0,
                      maxWidth: _showStart && _showEnd
                          ? endWidth
                          : contentWidth,
                      child: Padding(
                        padding: widget.style.endPadding,
                        child: widget.end,
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Divider
              if (widget.showVerticalDivider && _showStart && _showEnd)
                AnimatedPositioned(
                  duration: widget.style.animationDuration,
                  curve: widget.style.animationCurve,
                  left: isLTR ? startWidth : null,
                  right: isLTR ? null : startWidth,
                  top: 0,
                  bottom: 0,
                  width: widget.spacing,
                  child: const Center(
                    child: VerticalDivider(thickness: 1, width: 1),
                  ),
                ),

              // 4. Arrow Toggle
              if (!(widget.hideArrowIfTwoSidesVisible &&
                  _showStart &&
                  _showEnd))
                _buildAnimatedArrow(contentWidth, startWidth, minTwoSideWidth),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedArrow(
    double contentWidth,
    double startWidth,
    double minTwoSideWidth,
  ) {
    double? left;
    double? right;
    final isLTR = _dir == TextDirection.ltr;

    if (_showStart && _showEnd) {
      double pos =
          startWidth + (widget.spacing / 2) - (widget.style.arrowWidth / 2);
      if (isLTR)
        left = pos;
      else
        right = pos;
    } else {
      if (isLTR) {
        left = _showStart ? contentWidth - widget.style.arrowWidth : 0;
      } else {
        right = _showStart ? contentWidth - widget.style.arrowWidth : 0;
      }
    }

    return AnimatedPositioned(
      duration: widget.style.animationDuration,
      curve: widget.style.animationCurve,
      top: widget.arrowTopPosition,
      left: left,
      right: right,
      child: GestureDetector(
        onTap: () => _handleToggle(contentWidth, minTwoSideWidth),
        child: Container(
          width: widget.style.arrowWidth,
          height: widget.style.arrowHeight,
          decoration: BoxDecoration(
            color: widget.style.arrowButtonBackgroundColor,
            borderRadius:
                widget.style.arrowBorderRadius ?? BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4),
            ],
          ),
          child: Icon(
            _getCorrectIcon(contentWidth, minTwoSideWidth),
            size: 14,
            color: widget.style.arrowIconColor,
          ),
        ),
      ),
    );
  }

  IconData _getCorrectIcon(double contentWidth, double minTwoSideWidth) {
    bool isLTR = _dir == TextDirection.ltr;
    if (contentWidth < minTwoSideWidth) {
      return _showStart
          ? (isLTR ? Icons.arrow_back_ios : Icons.arrow_forward_ios)
          : (isLTR ? Icons.arrow_forward_ios : Icons.arrow_back_ios);
    }
    if (widget.fixedSide == FixedSide.start) {
      return _showStart
          ? (isLTR ? Icons.arrow_back_ios : Icons.arrow_forward_ios)
          : (isLTR ? Icons.arrow_forward_ios : Icons.arrow_back_ios);
    } else {
      return _showEnd
          ? (isLTR ? Icons.arrow_forward_ios : Icons.arrow_back_ios)
          : (isLTR ? Icons.arrow_back_ios : Icons.arrow_forward_ios);
    }
  }
}
