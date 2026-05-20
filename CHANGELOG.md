# Changelog

## 0.9.0

* **Breaking Changes & Style Modernization**
    * Integrated the new `flutter_artist_styles` design tokens ecosystem.
    * Replaced legacy raw color properties with standardized theme context extensions (`context.faColors`).
    * Updated default layout component colors to strictly bind with `faColors.common.transparent`, `faColors.divider.subtle`, `faColors.surface.emphasized`, and `faColors.action.ink.primary`.
    * Refactored `LeftRightContainerStyle` properties to support optional design token modifications (`startBackgroundColor`, `endBackgroundColor`, etc.) without breaking encapsulation.
* **Layout Enhancements**
    * Improved dynamic constraint recalculations inside `LayoutBuilder` when dealing with ultra-wide viewports.
    * Fine-tuned responsiveness of the floating arrow toggle positioning when panels are collapsed by the user.

## 0.0.1

### Added

- Initial release