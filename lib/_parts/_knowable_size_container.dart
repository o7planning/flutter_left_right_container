part of '../left_right_container.dart';

class _KnowableSizeContainer extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    double contentWidth,
  ) childBuilder;

  const _KnowableSizeContainer({
    required this.childBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double contentWidth = constraints.constrainWidth();
          return childBuilder(context, contentWidth);
        },
      ),
    );
  }
}
