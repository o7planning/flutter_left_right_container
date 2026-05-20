import 'package:flutter/material.dart';

import '../../left_right_container.dart';

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