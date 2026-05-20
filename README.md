# flutter_left_right_container

[![pub package](https://img.shields.io/pub/v/flutter_left_right_container.svg)](https://pub.dev/packages/flutter_left_right_container)
[![License: BSD-3](https://img.shields.io/badge/License-BSD--3-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

A highly responsive, dual-pane split container for Flutter. It seamlessly coordinates a two-sided view layout (`start` and `end`), featuring an elegant overlay toggle button that automatically adapts to varying screen constraints.

Perfect for master-detail views, collapsible sidebars, and enterprise-grade multi-pane dashboard configurations.

![LeftRightContainer Showcase](https://o7planning.github.io/docs/flutter/flutter_left_right_container/images/image.gif)


## 🚀 Key Features

* **Adaptive Dual Panels:** Gracefully structures layouts into independent `start` and `end` sections.
* **Fixed & Fluid Geometry:** Lock one target panel to a rigid width (`fixedSizeWidth`) while empowering the opposite section to dynamically expand and fill remaining space.
* **Intelligent Auto-Responsive Layouts:** Monitors parent constraints via `LayoutBuilder`. If screen real estate falls below your defined threshold, it fluidly consolidates into a single-pane viewport.
* **Interactive Floating Toggle Button:** Renders a floating directional button to smoothly collapse or reveal the primary sidebar content.
* **Deep Design Customizations:** Granular style overrides for panel margins, backgrounds, and custom floating arrow geometries using `LeftRightContainerStyle`.

## 🛠 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_left_right_container: ^latest_version
```

## 📖 Complete Usage Example

Below is an engineering snapshot showcasing how to implement `LeftRightContainer` inside a typical multi-pane enterprise view, mapping out structural decoration tokens and strict layout constraints.


![LeftRightContainer Example](https://o7planning.github.io/docs/flutter/flutter_left_right_container/images/example.gif)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_left_right_container/flutter_left_right_container.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: DashboardForm())));

class DashboardForm extends StatelessWidget {
  const DashboardForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enterprise Workspace')),
      body: LeftRightContainer(
        // 1. Core structural configurations
        fixedSide: FixedSide.start, // Left panel remains locked to fixedSizeWidth
        fixedSizeWidth: 280.0,      // Rigid width for the primary sidebar
        minSideWidth: 450.0,        // Minimum width required for the fluid side before collapsing
        spacing: 12.0,              // Gap width between panels
        arrowTopPosition: 120.0,    // Vertical offset for the floating trigger button
        
        // 2. Behavioral layout properties
        initiallyCollapsed: false,
        autoShowTwoSidesIfPossible: true,
        hideArrowIfTwoSidesVisible: false,
        showVerticalDivider: true,

        // 3. Left / Sidebar content
        start: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Navigation Menu', style: Theme.of(context).textTheme.titleMedium),
              const Divider(),
              const ListTile(leading: Icon(Icons.dashboard), title: Text('Analytics')),
              const ListTile(leading: Icon(Icons.settings), title: Text('Configuration')),
            ],
          ),
        ),

        // 4. Right / Main fluid content
        end: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => ListTile(
                title: Text('Transaction Ledger Record #${index + 1}'),
                subtitle: const Text('Status: Processed and synchronized'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),

        // 5. Explicit Style & Token definitions
        style: LeftRightContainerStyle(
          backgroundColor: Colors.grey[50],
          startBackgroundColor: Colors.white,
          endBackgroundColor: Colors.transparent,
          startPadding: const EdgeInsets.all(16.0),
          endPadding: const EdgeInsets.all(8.0),
          arrowButtonBackgroundColor: Colors.blueAccent,
          arrowIconColor: Colors.white,
          arrowWidth: 24.0,
          arrowHeight: 36.0,
          arrowBorderRadius: BorderRadius.circular(6.0),
        ),
      ),
    );
  }
}
```

## 📐 Properties API Reference

| Parameter | Type | Default | Description |
|---|---|---|---|
| `start` | `Widget` | *Required* | The primary left-hand side canvas component. |
| `end` | `Widget` | *Required* | The primary right-hand side canvas component. |
| `fixedSizeWidth` | `double` | *Required* | Explicit horizontal width applied to the static sidebar. |
| `minSideWidth` | `double` | *Required* | Threshold constraint allocated to the adaptive fluid content container. |
| `fixedSide` | `FixedSide` | `FixedSide.start` | Determines whether the left (`start`) or right (`end`) panel behaves as the static component. |
| `spacing` | `double` | `0` | Width of the separator layout gap inserted between active panels. |
| `arrowTopPosition` | `double` | `50` | Vertical placement anchor boundary for the floating control toggle. |
| `initiallyCollapsed` | `bool` | `false` | When true, renders the view with the target static sidebar hidden. |
| `autoShowTwoSidesIfPossible` | `bool` | `true` | Automatically splits view into dual panels if aggregate screen space permits. |
| `hideArrowIfTwoSidesVisible` | `bool` | `false` | Strips out the overlay control toggle whenever screen dimensions explicitly comfortably support both panes. |
| `showVerticalDivider` | `bool` | `true` | Embeds a native standard `VerticalDivider` element directly between active view panels. |
| `style` | `LeftRightContainerStyle` | `const LeftRightContainerStyle()` | Deep nested formatting object detailing layout token colors and animation structures. |
