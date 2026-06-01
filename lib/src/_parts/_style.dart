part of '../../flutter_left_right_container.dart';

/// A highly comprehensive styling and appearance token structure governing
/// the presentation canvas dimensions, speeds, and colors of the left-right split container.
class LeftRightContainerStyle {
  /// The concrete background color canvas specification rule applied to the start (left) layout pane.
  final Color? startBackgroundColor;

  /// The concrete background color canvas specification rule applied to the end (right) layout pane.
  final Color? endBackgroundColor;

  /// The global boundary background color fill applied directly underneath both container layouts.
  final Color? backgroundColor;

  /// The spacing internal padding metrics enforced around the content boundaries of the start pane.
  final EdgeInsets startPadding;

  /// The spacing internal padding metrics enforced around the content boundaries of the end pane.
  final EdgeInsets endPadding;

  /// The background canvas color asset governing the interactive split action trigger toggle arrow button button.
  final Color? arrowButtonBackgroundColor;

  /// The material icon vector highlight coloring applied directly over the toggle arrow symbols.
  final Color? arrowIconColor;

  /// The explicit layout cross-axis thickness width allocated to the mid-split toggle trigger boundary.
  final double arrowWidth;

  /// The explicit layout main-axis height dimension allocated to the mid-split toggle trigger boundary.
  final double arrowHeight;

  /// The geometric corner clipping boundary radius mapping applied to the navigation toggle button layout.
  final BorderRadius? arrowBorderRadius;

  /// The runtime lifecycle timeframe speed configuration tracking pane co-sliding motion behaviors.
  final Duration animationDuration;

  /// The behavioral velocity transition curve matrix formula regulating pane slider motion paths.
  final Curve animationCurve;

  /// Instantiates an absolute, immutable style token profile mapping dual-pane visual constraints.
  const LeftRightContainerStyle({
    this.startBackgroundColor,
    this.endBackgroundColor,
    this.backgroundColor,
    this.startPadding = const EdgeInsets.all(5),
    this.endPadding = const EdgeInsets.all(5),
    this.arrowButtonBackgroundColor,
    this.arrowIconColor,
    this.arrowWidth = 20,
    this.arrowHeight = 30,
    this.arrowBorderRadius,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.fastOutSlowIn,
  });
}
