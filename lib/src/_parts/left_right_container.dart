part of '../../flutter_left_right_container.dart';

/// An advanced, flexible dual-pane layout builder widget featuring sliding co-expansion transitions.
///
/// It orchestrates two adjacent child containers ([start] and [end]) separated by an active
/// responsive divider track, supporting automatic dimension-tracking and animated collapse states.
class LeftRightContainer extends StatefulWidget {
  /// The presentation widget tree configuration mounted inside the left or starting viewport track.
  final Widget start;

  /// The presentation widget tree configuration mounted inside the right or ending viewport track.
  final Widget end;

  /// The static, non-expandable width boundary threshold assigned onto the designated [fixedSide] viewport.
  final double fixedSizeWidth;

  /// The baseline lower-bound width limit that the flexible adaptive side pane must preserve before triggering clip lines.
  final double minSideWidth;

  /// Determines which structural pane layer anchors the static hardcoded pixel dimensions metric pass.
  final FixedSide fixedSide;

  /// The absolute horizontal separation spacing layout gap cleared out between the start and end container panels.
  final double spacing;

  /// The vertical layout offset percentage placement governing where the interactive arrow anchor sits along the viewport track.
  final double arrowTopPosition;

  /// Dictates if the flexible panel boundaries should immediately initialize under a completely collapsed layout track state.
  final bool initiallyCollapsed;

  /// Automatically displays both panels concurrently whenever the host context provides sufficient horizontal space metrics.
  final bool autoShowTwoSidesIfPossible;

  /// Hides the interactive co-sliding arrow trigger asset completely if both layout windows possess enough space to stand visible.
  final bool hideArrowIfTwoSidesVisible;

  /// Embeds a sharp vertical line separator tracking between adjacent start and end block interfaces.
  final bool showVerticalDivider;

  /// The centralized aesthetic look-and-feel engine theme constants regulating animations and colors.
  final LeftRightContainerStyle style;

  /// Constructs a standard, production-ready declarative instance of [LeftRightContainer].
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
        widget.style.backgroundColor ?? context.faColors.common.transparent;
    final Color startBg =
        widget.style.startBackgroundColor ??
        context.faColors.common.transparent;
    final Color endBg =
        widget.style.endBackgroundColor ?? context.faColors.common.transparent;

    final Color dividerColor = context.faColors.divider.subtle;

    final Color arrowBg =
        widget.style.arrowButtonBackgroundColor ??
        context.faColors.surface.emphasized.withValues(alpha: 0.9);

    final Color arrowIconColor =
        widget.style.arrowIconColor ?? context.faColors.action.ink.primary;

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
