### Examples:

```dart
LeftRightContainer(
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
```

![](https://raw.githubusercontent.com/o7planning/flutter_left_right_container/refs/heads/main/doc/images/pic1.gif)

![](https://raw.githubusercontent.com/o7planning/flutter_left_right_container/refs/heads/main/doc/images/pic2.gif)