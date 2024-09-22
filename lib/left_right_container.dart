import 'package:flutter/material.dart';

part '_parts/_knowable_size_container.dart';

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
  final double minLeftWidth;
  final double minSideWidth;
  final FixedSide fixedSide;
  final bool hideDividerInLargeSize;
  final double spacing;
  final Color arrowButtonBackgroundColor;
  final Color? leftBackgroundColor;
  final Color? rightBackgroundColor;

  const LeftRightContainer({
    super.key,
    this.spacing = 0,
    this.arrowTopPosition = 0,
    required this.fixedSizeWidth,
    required this.end,
    required this.start,
    required this.minLeftWidth,
    required this.minSideWidth,
    this.minHeight,
    this.fixedSide = FixedSide.start,
    this.initiallyCollapsed = false,
    this.hideDividerInLargeSize = false,
    this.arrowButtonBackgroundColor = Colors.white,
    this.leftBackgroundColor,
    this.rightBackgroundColor,
  });

  @override
  State<StatefulWidget> createState() {
    return _LeftRightContainerState();
  }
}

class _LeftRightContainerState extends State<LeftRightContainer> {
  bool showStart = true;
  bool showEnd = true;
  static const double buttonContainerWidth = 18;
  static const double buttonContainerHeight = 22;
  static const double iconSize = 14;

  double? leftHeight;
  double? rightHeight;

  static const double maxHeight = 10000;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _KnowableSizeContainer(
      childBuilder: (
        BuildContext context,
        double contentWidth,
        double contentHeight,
      ) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: widget.minHeight ?? 0,
          ),
          child: _buildStack(
            context,
            contentWidth,
            contentHeight,
          ),
        );
      },
    );
  }

  bool canExpandLeftMore() {
    if (widget.fixedSide == FixedSide.start) {
      return !showStart;
    } else {
      return !showStart || showEnd;
    }
  }

  bool canExpandRightMore() {
    if (widget.fixedSide == FixedSide.end) {
      return !showEnd;
    } else {
      return !showEnd || showStart;
    }
  }

  void expandLeft(double contentWidth, double min) {
    if (!canExpandLeftMore()) {
      return;
    }
    setState(() {
      if (contentWidth < min) {
        showStart = true;
        showEnd = false;
      } else {
        if (!showStart) {
          showStart = true;
          showEnd = true;
        } else {
          showStart = true;
          showEnd = false;
        }
      }
    });
  }

  void expandRight(double contentWidth, double min) {
    if (!canExpandRightMore()) {
      return;
    }
    setState(() {
      if (contentWidth < min) {
        showEnd = true;
        showStart = false;
      } else {
        if (!showEnd) {
          showEnd = true;
          showStart = true;
        } else {
          showEnd = true;
          showStart = false;
        }
      }
    });
  }

  double _leftWidth(double contentWidth) {
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

  double _rightWidth(double contentWidth) {
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
    double contentHeight,
  ) {
    double min = widget.fixedSide == FixedSide.start
        ? widget.fixedSizeWidth + widget.spacing + widget.minSideWidth
        : widget.minLeftWidth + widget.spacing + widget.fixedSizeWidth;
    //
    if (!showStart && !showEnd) {
      if (widget.fixedSide == FixedSide.start) {
        showEnd = true;
      } else {
        showStart = true;
      }
    } else if (showStart && showEnd && contentWidth < min) {
      if (widget.fixedSide == FixedSide.start) {
        showEnd = true;
        showStart = false;
      } else {
        showStart = true;
        showEnd = false;
      }
    }
    //
    var dividerPosition =
        widget.fixedSizeWidth + widget.spacing / 2 - buttonContainerWidth / 2;
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        if (showStart)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: _leftWidth(contentWidth),
              height: maxHeight,
              color: widget.leftBackgroundColor,
            ),
          ),
        if (showEnd)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: _rightWidth(contentWidth),
              height: maxHeight,
              color: widget.rightBackgroundColor,
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (showStart)
              widget.fixedSide == FixedSide.start && showEnd
                  ? SizedBox(
                      width: widget.fixedSizeWidth,
                      child: widget.start,
                    )
                  : Expanded(
                      child: widget.start,
                    ),
            if (showStart && showEnd) SizedBox(width: widget.spacing),
            if (showEnd)
              widget.fixedSide == FixedSide.end && showStart
                  ? SizedBox(
                      width: widget.fixedSizeWidth,
                      child: widget.end,
                    )
                  : Expanded(
                      child: widget.end,
                    ),
          ],
        ),
        if (showEnd && showStart)
          Positioned(
            top: 0,
            right: widget.fixedSide == FixedSide.start
                ? null
                : showEnd
                    ? widget.fixedSizeWidth
                    : 0,
            left: widget.fixedSide == FixedSide.end
                ? null
                : showStart
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
        if (!(widget.hideDividerInLargeSize && showStart && showEnd))
          Positioned(
            top: widget.arrowTopPosition,
            right: widget.fixedSide == FixedSide.start
                ? showStart
                    ? showEnd
                        ? null // FixSide.left & showLeft & showRight
                        : 0 // FixSide.left & showLeft & !showRight
                    : showEnd
                        ? null // FixSide.left & !showLeft & showRight
                        : null // FixSide.left & !showLeft & !showRight
                : showStart // FixSide.right
                    ? showEnd
                        ? dividerPosition // FixSide.right & showLeft & showRight
                        : 0 // FixSide.right & showLeft & !showRight
                    : showEnd
                        ? null // FixSide.right & !showLeft & showRight
                        : null, // FixSide.right & !showLeft & !showRight
            left: widget.fixedSide == FixedSide.start
                ? showStart
                    ? showEnd
                        ? dividerPosition // FixSide.left & showLeft & showRight
                        : null // FixSide.left & showLeft & !showRight
                    : showEnd
                        ? 0 // FixSide.left & !showLeft & showRight
                        : null // FixSide.left & !showLeft & !showRight
                : showStart // FixSide.right
                    ? showEnd
                        ? null // FixSide.right & showLeft & showRight
                        : null // FixSide.right & showLeft & !showRight
                    : showEnd
                        ? 0 // FixSide.right & !showLeft & showRight
                        : null, // FixSide.right & !showLeft & !showRight
            child: _buildArrow(contentWidth, min),
          ),
      ],
    );
  }

  Widget _buildArrow(double contentWidth, double min) {
    return Container(
      width: 20,
      height: 30,
      decoration: BoxDecoration(
        color: widget.arrowButtonBackgroundColor,
        // Màu nền xung quanh icon
        shape: BoxShape.rectangle,
        // Hình dạng hình vuông
        borderRadius: BorderRadius.circular(2),
        // Điều chỉnh góc bo cho hình vuông
        border: Border.all(
          // Thêm đường viền
          color: Colors.grey.shade300, // Màu của đường viền là màu xám (grey)
          width: 1.0, // Độ rộng của đường viền
        ),
      ),
      child: Material(
        child: InkWell(
          child: Icon(
            canExpandLeftMore() ? Icons.arrow_forward : Icons.arrow_back,
            size: iconSize,
            color: Colors.black,
          ),
          onTap: () {
            if (canExpandLeftMore()) {
              expandLeft(contentWidth, min);
            } else {
              expandRight(contentWidth, min);
            }
          },
        ),
      ),
    );
  }
}
