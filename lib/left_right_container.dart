import 'package:flutter/material.dart';

part '_parts/_knowable_size_container.dart';
part '_parts/_size_measure_widget.dart';

enum FixedSide {
  start,
  end;
}

class LeftRightContainer extends StatefulWidget {
  final double arrowTopPosition;
  final double fixedSizeWidth;
  final Widget end;
  final Widget start;
  final bool initiallyCollapsed;
  final double? minHeight;
  final double minSideWidth;
  final FixedSide fixedSide;
  final bool hideArrowIfTwoSidesVisible;
  final bool showVerticalDivider;
  final bool autoShowTwoSidesIfPossible;
  final double spacing;
  final Color arrowButtonBackgroundColor;
  final Color arrowIconColor;
  final Color? startBackgroundColor;
  final Color? endBackgroundColor;
  final Color? backgroundColor;
  final EdgeInsets startPadding;
  final EdgeInsets endPadding;
  final TextDirection? textDirection;

  const LeftRightContainer({
    super.key,
    this.spacing = 0,
    this.arrowTopPosition = 0,
    required this.fixedSizeWidth,
    required this.end,
    required this.start,
    required this.minSideWidth,
    this.minHeight,
    this.fixedSide = FixedSide.start,
    this.initiallyCollapsed = false,
    this.hideArrowIfTwoSidesVisible = false,
    this.showVerticalDivider = true,
    this.autoShowTwoSidesIfPossible = false,
    this.arrowButtonBackgroundColor = Colors.white,
    this.arrowIconColor = Colors.black,
    this.startBackgroundColor,
    this.endBackgroundColor,
    this.backgroundColor,
    this.startPadding = const EdgeInsets.all(10),
    this.endPadding = const EdgeInsets.all(10),
    this.textDirection,
  });

  @override
  State<StatefulWidget> createState() {
    return _LeftRightContainerState();
  }
}

class _LeftRightContainerState extends State<LeftRightContainer> {
  late TextDirection _textDirection;
  bool showStart = true;
  bool showEnd = true;
  double arrowContainerWidth = 20;
  double arrowContainerHeight = 30;
  static const double iconSize = 14;

  double? leftHeight;
  double? rightHeight;

  bool collapsedByUser = false;

  static const double maxHeight = 10000;

  @override
  void initState() {
    super.initState();
    if (widget.initiallyCollapsed) {
      if (widget.fixedSide == FixedSide.start) {
        showStart = false;
        showEnd = true;
      } else {
        showStart = true;
        showEnd = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _textDirection = widget.textDirection ?? Directionality.of(context);
    //
    return _KnowableSizeContainer(
      childBuilder: (
        BuildContext context,
        double contentWidth,
      ) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: widget.minHeight ?? 0,
          ),
          child: _buildStack(
            context,
            contentWidth,
          ),
        );
      },
    );
  }

  bool canExpandStartMore() {
    if (widget.fixedSide == FixedSide.start) {
      return !showStart;
    } else {
      return !showStart || showEnd;
    }
  }

  bool canExpandEndMore() {
    if (widget.fixedSide == FixedSide.end) {
      return !showEnd;
    } else {
      return !showEnd || showStart;
    }
  }

  void _expandStart(double contentWidth, double minTwoSideWidth) {
    if (!canExpandStartMore()) {
      return;
    }
    setState(() {
      if (contentWidth < minTwoSideWidth) {
        showStart = true;
        showEnd = false;
      } else {
        if (!showStart) {
          showStart = true;
          showEnd = true;
          collapsedByUser = false;
        } else {
          showStart = true;
          showEnd = false;
          collapsedByUser = true;
        }
      }
    });
  }

  void _expandEnd(double contentWidth, double minTwoSideWidth) {
    if (!canExpandEndMore()) {
      return;
    }
    setState(() {
      if (contentWidth < minTwoSideWidth) {
        showEnd = true;
        showStart = false;
      } else {
        if (!showEnd) {
          showEnd = true;
          showStart = true;
          collapsedByUser = false;
        } else {
          showEnd = true;
          showStart = false;
          collapsedByUser = true;
        }
      }
    });
  }

  double _startWidth(double contentWidth) {
    if (widget.fixedSide == FixedSide.start) {
      if (showStart && showEnd) {
        return widget.fixedSizeWidth;
      } else if (showStart) {
        return contentWidth;
      } else if (showEnd) {
        return 0;
      }
      return 0;
    } else {
      if (showStart && showEnd) {
        return contentWidth - widget.spacing - widget.fixedSizeWidth;
      } else if (showStart) {
        return contentWidth;
      } else if (showEnd) {
        return 0;
      }
      return 0;
    }
  }

  double _endWidth(double contentWidth) {
    if (widget.fixedSide == FixedSide.end) {
      if (showStart && showEnd) {
        return widget.fixedSizeWidth;
      } else if (showEnd) {
        return contentWidth;
      } else if (showStart) {
        return 0;
      }
      return 0;
    } else {
      if (showStart && showEnd) {
        return contentWidth - widget.spacing - widget.fixedSizeWidth;
      } else if (showEnd) {
        return contentWidth;
      } else if (showStart) {
        return 0;
      }
      return 0;
    }
  }

  Widget _buildStack(
    BuildContext context,
    double contentWidth,
  ) {
    double minTwoSideWidth =
        widget.fixedSizeWidth + widget.spacing + widget.minSideWidth;
    //
    if (!showStart && !showEnd) {
      if (widget.fixedSide == FixedSide.start) {
        showEnd = true;
      } else {
        showStart = true;
      }
    } else if (showStart && showEnd && contentWidth < minTwoSideWidth) {
      if (widget.fixedSide == FixedSide.start) {
        showEnd = true;
        showStart = false;
      } else {
        showStart = true;
        showEnd = false;
      }
    }
    if (!collapsedByUser &&
        widget.autoShowTwoSidesIfPossible &&
        contentWidth >= minTwoSideWidth) {
      showEnd = true;
      showStart = true;
    }
    //
    var arrowPosition =
        widget.fixedSizeWidth + widget.spacing / 2 - arrowContainerWidth / 2;
    //
    return Container(
      color: widget.backgroundColor,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          if (showStart)
            Positioned(
              top: 0,
              left: _textDirection == TextDirection.ltr ? 0 : null,
              right: _textDirection == TextDirection.ltr ? null : 0,
              child: Container(
                width: _startWidth(contentWidth),
                height: maxHeight,
                color: widget.startBackgroundColor,
              ),
            ),
          if (showEnd)
            Positioned(
              top: 0,
              right: _textDirection == TextDirection.ltr ? 0 : null,
              left: _textDirection == TextDirection.ltr ? null : 0,
              child: Container(
                width: _endWidth(contentWidth),
                height: maxHeight,
                color: widget.endBackgroundColor,
              ),
            ),
          Row(
            textDirection: _textDirection,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (showStart)
                widget.fixedSide == FixedSide.start && showEnd
                    ? SizedBox(
                        width: widget.fixedSizeWidth,
                        child: Padding(
                          padding: widget.startPadding,
                          child: widget.start,
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: widget.startPadding,
                          child: widget.start,
                        ),
                      ),
              if (showStart && showEnd) SizedBox(width: widget.spacing),
              if (showEnd)
                widget.fixedSide == FixedSide.end && showStart
                    ? SizedBox(
                        width: widget.fixedSizeWidth,
                        child: Padding(
                          padding: widget.endPadding,
                          child: widget.end,
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: widget.endPadding,
                          child: widget.end,
                        ),
                      ),
            ],
          ),
          if (widget.showVerticalDivider && showEnd && showStart)
            Positioned(
              top: 0,
              right: _textDirection == TextDirection.ltr
                  ? widget.fixedSide == FixedSide.start
                      ? null
                      : showEnd
                          ? widget.fixedSizeWidth
                          : 0
                  : widget.fixedSide == FixedSide.end // *******
                      ? null
                      : showStart
                          ? widget.fixedSizeWidth
                          : 0,
              left: _textDirection == TextDirection.ltr
                  ? widget.fixedSide == FixedSide.end
                      ? null
                      : showStart
                          ? widget.fixedSizeWidth
                          : 0
                  : widget.fixedSide == FixedSide.start // *******
                      ? null
                      : showEnd
                          ? widget.fixedSizeWidth
                          : 0,
              child: SizedBox(
                width: widget.spacing,
                height: maxHeight,
                child: const Center(
                  child: VerticalDivider(),
                ),
              ),
            ),
          if (!(widget.hideArrowIfTwoSidesVisible && showStart && showEnd))
            Positioned(
              top: widget.arrowTopPosition,
              right: _textDirection == TextDirection.ltr
                  ? widget.fixedSide == FixedSide.start
                      ? showStart
                          ? showEnd
                              ? null // LTR & FixedSide.start & showStart & showEnd
                              : 0 // LTR & FixedSide.start & showStart & !showEnd
                          : showEnd
                              ? null // LTR & FixedSide.start & !showStart & showEnd
                              : null // LTR & FixedSide.start & !showStart & !showEnd
                      : showStart // FixedSide.end
                          ? showEnd
                              ? arrowPosition // LTR & FixedSide.end & showStart & showEnd
                              : 0 // LTR & FixedSide.end & showStart & !showEnd
                          : showEnd
                              ? null // LTR & FixedSide.end & !showStart & showEnd
                              : null
                  : widget.fixedSide == FixedSide.start // ************
                      ? showStart
                          ? showEnd
                              ? arrowPosition // RTL & FixedSide.start & showStart & showEnd
                              : null // RTL & FixedSide.start & showStart & !showEnd
                          : showEnd
                              ? 0 // RTL & FixedSide.start & !showStart & showEnd
                              : null // RTL & FixedSide.start & !showStart & !showEnd
                      : showStart // FixedSide.end
                          ? showEnd
                              ? null // RTL & FixedSide.end & showStart & showEnd
                              : null // RTL & FixedSide.end & showStart & !showEnd
                          : showEnd
                              ? 0 // RTL & FixedSide.end & !showStart & showEnd
                              : null, // RTL & FixedSide.end & !showStart & !showEnd
              left: _textDirection == TextDirection.ltr
                  ? widget.fixedSide == FixedSide.start
                      ? showStart
                          ? showEnd
                              ? arrowPosition // LTF & FixedSide.start & showStart & showEnd
                              : null // LTF & FixedSide.start & showStart & !showEnd
                          : showEnd
                              ? 0 // LTF & FixedSide.start & !showStart & showEnd
                              : null // LTF & FixedSide.start & !showStart & !showEnd
                      : showStart // FixedSide.end
                          ? showEnd
                              ? null // LTF & FixedSide.end & showStart & showEnd
                              : null // LTF & FixedSide.end & showStart & !showEnd
                          : showEnd
                              ? 0 // LTF & FixedSide.end & !showStart & showEnd
                              : null
                  : widget.fixedSide == FixedSide.start // *******
                      ? showStart
                          ? showEnd
                              ? null // RTL & FixedSide.start & showStart & showEnd
                              : 0 // RTL & FixedSide.start & showStart & !showEnd
                          : showEnd
                              ? null // RTL & FixedSide.start & !showStart & showEnd
                              : null // RTL & FixedSide.start & !showStart & !showEnd
                      : showStart // FixedSide.end
                          ? showEnd
                              ? arrowPosition // RTL & FixedSide.end & showStart & showEnd
                              : 0 // RTL & FixedSide.end & showStart & !showEnd
                          : showEnd
                              ? null // RTL & FixedSide.end & !showStart & showEnd
                              : null, // RTL & FixedSide.end & !showStart & !showEnd
              child: _buildArrow(contentWidth, minTwoSideWidth),
            ),
        ],
      ),
    );
  }

  Widget _buildArrow(double contentWidth, double minTwoSideWidth) {
    return _SizeMeasureWidget(
      onSizeMeasured: (Size value) {
        setState(() {
          arrowContainerWidth = value.width;
          arrowContainerHeight = value.height;
        });
      },
      child: Container(
        width: 20,
        height: 30,
        decoration: BoxDecoration(
          color: widget.arrowButtonBackgroundColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
        child: Material(
          child: InkWell(
            child: Icon(
              textDirection: _textDirection,
              canExpandStartMore() //
                  ? Icons.arrow_forward
                  : Icons.arrow_back,
              size: iconSize,
              color: widget.arrowIconColor,
            ),
            onTap: () {
              if (canExpandStartMore()) {
                _expandStart(contentWidth, minTwoSideWidth);
              } else {
                _expandEnd(contentWidth, minTwoSideWidth);
              }
            },
          ),
        ),
      ),
    );
  }
}
