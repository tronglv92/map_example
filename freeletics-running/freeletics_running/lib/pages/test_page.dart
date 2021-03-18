import 'package:flutter/material.dart';

import 'circle_painter.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>  {
  double currentProgress = 0;
@override
  void didUpdateWidget(covariant TestPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
   print("didUpdateWidget");

  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("didChangeDependencies");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 300,
        width: 300,
        child: CustomPaint(
          painter: CirclePainter(currentProgress: currentProgress),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Center(
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          setState(() {
            currentProgress = currentProgress + 10;
          });
        },
      ),
    );
  }
}
