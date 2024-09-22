part of '../left_right_container.dart';

class _KnowableSizeContainer extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;

  final Widget Function(
    BuildContext context,
    double contentWidth,
    double contentHeight,
  ) childBuilder;

  const _KnowableSizeContainer({
    required this.childBuilder,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double contentWidth = constraints.constrainWidth();
          double contentHeight = constraints.constrainHeight();
          if (contentWidth != double.infinity) {
            contentWidth -= (margin == null ? 0 : margin!.horizontal);
            contentWidth -= (padding == null ? 0 : padding!.horizontal);
          }
          if (contentHeight != double.infinity) {
            contentHeight -= (margin == null ? 0 : margin!.vertical);
            contentHeight -= (padding == null ? 0 : padding!.vertical);
          }
          return childBuilder(context, contentWidth, contentHeight);
        },
      ),
    );
  }
}
