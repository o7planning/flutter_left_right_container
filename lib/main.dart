import 'package:flutter/material.dart';
import 'package:flutter_left_right_container/left_right_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: LeftRightContainer(
          fixedSizeWidth: 200,
          end: SizedBox(
            height: 300,
            child: Text("End"),
          ),
          start: SizedBox(
            height: 400,
            child: Text("Start"),
          ),
          minLeftWidth: 400,
          minSideWidth: 400,
          spacing: 20,
          arrowTopPosition: 30,
          leftBackgroundColor: Colors.red,
          rightBackgroundColor: Colors.green,
        ),
      ),
    );
  }
}
