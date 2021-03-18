import 'package:flutter/material.dart';
class AppBarEmpty extends StatelessWidget {
  AppBarEmpty({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Container(
        child: child,
      ),
    );
  }
}
