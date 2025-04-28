import 'package:flutter/material.dart';
import 'package:flutter_left_right_container/left_right_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Directionality(
        // use this
        textDirection: TextDirection.ltr, // set it to rtl
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
      //  home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: LeftRightContainer(
          // textDirection: TextDirection.ltr,
          fixedSide: FixedSide.end,
          fixedSizeWidth: 200,
          initiallyCollapsed: true,
          hideArrowIfTwoSidesVisible: false,
          autoShowTwoSidesIfPossible: true,
          showVerticalDivider: true,
          end: SizedBox(
            height: 300,
            child: Text("End"),
          ),
          start: SizedBox(
            height: 300,
            child: Text("Start"),
          ),
          minSideWidth: 400,
          spacing: 10,
          arrowTopPosition: 30,
          backgroundColor: Colors.yellow,
          startBackgroundColor: Colors.red,
          endBackgroundColor: Colors.green,
          minHeight: 300,
        ),
      ),
    );
  }
}
