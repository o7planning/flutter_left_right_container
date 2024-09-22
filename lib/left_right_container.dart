import 'package:flutter/material.dart'; 

part '_parts/_knowable_size_container.dart';

enum FixedSide {
  left,
  right;
}

class LeftRightContainer extends StatefulWidget {
  final double arrowTopPosition;
  final double sidebarWidth;
  final Widget right;
  final Widget left;
  final bool initiallyCollapsed;
  final double? minHeight;
  final double minLeftWidth;
  final double minRightWidth;
  final FixedSide fixSide;
  final bool hideDividerInLargeSize;
  final double spacing;
  final Color arrowButtonBackgroundColor;
  final Color? leftBackgroundColor;
  final Color? rightBackgroundColor;

  const LeftRightContainer({
    super.key,
    this.spacing = 0,
    this.arrowTopPosition = 0,
    required this.sidebarWidth,
    required this.right,
    required this.left,
    required this.minLeftWidth,
    required this.minRightWidth,
    this.minHeight,
    this.fixSide = FixedSide.left,
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
  bool showLeft = true;
  bool showRight = true;
  static const double buttonContainerWidth = 18;
  static const double buttonContainerHeight = 22;
  static const double iconSize = 14;

  double? leftHeight;
  double? rightHeight;

  static const double maxHeight = 10000;

  @override
  void initState() {
    // _horizontal = widget.initiallyCollapsed;
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
    if (widget.fixSide == FixedSide.left) {
      return !showLeft;
    } else {
      return !showLeft || showRight;
    }
  }

  bool canExpandRightMore() {
    if (widget.fixSide == FixedSide.right) {
      return !showRight;
    } else {
      return !showRight || showLeft;
    }
  }

  void expandLeft(double contentWidth, double min) {
    if (!canExpandLeftMore()) {
      return;
    }
    setState(() {
      if (contentWidth < min) {
        showLeft = true;
        showRight = false;
      } else {
        if (!showLeft) {
          showLeft = true;
          showRight = true;
        } else {
          showLeft = true;
          showRight = false;
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
        showRight = true;
        showLeft = false;
      } else {
        if (!showRight) {
          showRight = true;
          showLeft = true;
        } else {
          showRight = true;
          showLeft = false;
        }
      }
    });
  }

  double _leftWidth(double contentWidth) {
    if (widget.fixSide == FixedSide.left) {
      if (showLeft && showRight) {
        return widget.sidebarWidth;
      } else if (showLeft) {
        return contentWidth;
      } else if (showRight) {
        return 0;
      }
      return 0;
    } else {
      if (showLeft && showRight) {
        return contentWidth - widget.spacing - widget.sidebarWidth;
      } else if (showLeft) {
        return contentWidth;
      } else if (showRight) {
        return 0;
      }
      return 0;
    }
  }

  double _rightWidth(double contentWidth) {
    if (widget.fixSide == FixedSide.right) {
      if (showLeft && showRight) {
        return widget.sidebarWidth;
      } else if (showRight) {
        return contentWidth;
      } else if (showLeft) {
        return 0;
      }
      return 0;
    } else {
      if (showLeft && showRight) {
        return contentWidth - widget.spacing - widget.sidebarWidth;
      } else if (showRight) {
        return contentWidth;
      } else if (showLeft) {
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
    double min = widget.fixSide == FixedSide.left
        ? widget.sidebarWidth + widget.spacing + widget.minRightWidth
        : widget.minLeftWidth + widget.spacing + widget.sidebarWidth;
    //
    if (!showLeft && !showRight) {
      if (widget.fixSide == FixedSide.left) {
        showRight = true;
      } else {
        showLeft = true;
      }
    } else if (showLeft && showRight && contentWidth < min) {
      if (widget.fixSide == FixedSide.left) {
        showRight = true;
        showLeft = false;
      } else {
        showLeft = true;
        showRight = false;
      }
    }
    //
    var dividerPosition =
        widget.sidebarWidth + widget.spacing / 2 - buttonContainerWidth / 2;
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        if (showLeft)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: _leftWidth(contentWidth),
              height: maxHeight,
              color: widget.leftBackgroundColor,
            ),
          ),
        if (showRight)
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
            if (showLeft)
              widget.fixSide == FixedSide.left && showRight
                  ? SizedBox(
                width: widget.sidebarWidth,
                child: widget.left,
              )
                  : Expanded(
                child: widget.left,
              ),
            if (showLeft && showRight) SizedBox(width: widget.spacing),
            if (showRight)
              widget.fixSide == FixedSide.right && showLeft
                  ? SizedBox(
                width: widget.sidebarWidth,
                child: widget.right,
              )
                  : Expanded(
                child: widget.right,
              ),
          ],
        ),
        if (showRight && showLeft)
          Positioned(
            top: 0,
            right: widget.fixSide == FixedSide.left
                ? null
                : showRight
                ? widget.sidebarWidth
                : 0,
            left: widget.fixSide == FixedSide.right
                ? null
                : showLeft
                ? widget.sidebarWidth
                : 0,
            child: SizedBox(
              width: widget.spacing,
              height: maxHeight,
              child: const Center(
                child: VerticalDivider(),
              ),
            ),
          ),
        if (!(widget.hideDividerInLargeSize && showLeft && showRight))
          Positioned(
            top: widget.arrowTopPosition,
            right: widget.fixSide == FixedSide.left
                ? showLeft
                ? showRight
                ? null // FixSide.left & showLeft & showRight
                : 0 // FixSide.left & showLeft & !showRight
                : showRight
                ? null // FixSide.left & !showLeft & showRight
                : null // FixSide.left & !showLeft & !showRight
                : showLeft // FixSide.right
                ? showRight
                ? dividerPosition // FixSide.right & showLeft & showRight
                : 0 // FixSide.right & showLeft & !showRight
                : showRight
                ? null // FixSide.right & !showLeft & showRight
                : null, // FixSide.right & !showLeft & !showRight
            left: widget.fixSide == FixedSide.left
                ? showLeft
                ? showRight
                ? dividerPosition // FixSide.left & showLeft & showRight
                : null // FixSide.left & showLeft & !showRight
                : showRight
                ? 0 // FixSide.left & !showLeft & showRight
                : null // FixSide.left & !showLeft & !showRight
                : showLeft // FixSide.right
                ? showRight
                ? null // FixSide.right & showLeft & showRight
                : null // FixSide.right & showLeft & !showRight
                : showRight
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
