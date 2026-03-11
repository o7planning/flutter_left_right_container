part of '../../left_right_container.dart';

class LeftRightContainerStyle {
  final Color? startBackgroundColor;
  final Color? endBackgroundColor;
  final Color? backgroundColor;
  final EdgeInsets startPadding;
  final EdgeInsets endPadding;
  final Color arrowButtonBackgroundColor;
  final Color arrowIconColor;
  final double arrowWidth;
  final double arrowHeight;
  final BorderRadius? arrowBorderRadius;
  final Duration animationDuration;
  final Curve animationCurve;

  const LeftRightContainerStyle({
    this.startBackgroundColor,
    this.endBackgroundColor,
    this.backgroundColor,
    this.startPadding = const EdgeInsets.all(5),
    this.endPadding = const EdgeInsets.all(5),
    this.arrowButtonBackgroundColor = Colors.white,
    this.arrowIconColor = Colors.black,
    this.arrowWidth = 20,
    this.arrowHeight = 30,
    this.arrowBorderRadius,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });
}
