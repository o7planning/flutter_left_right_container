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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: LeftRightContainer(
          fixedSizeWidth: 200,
          initiallyCollapsed: true,
          hideArrowIfTwoSidesVisible: false,
          autoShowTwoSidesIfPossible: true,
          showVerticalDivider: false,
          end: SizedBox(
            height: 300,
            child: Text("End"),
          ),
          start: SizedBox(
            height: 400,
            child: Text("Start"),
          ),
          minSideWidth: 400,
          spacing: 10,
          arrowTopPosition: 30,
          backgroundColor: Colors.yellow,
          startBackgroundColor: Colors.red,
          endBackgroundColor: Colors.green,
          minHeight: 500,
        ),
      ),
    );
  }
}
