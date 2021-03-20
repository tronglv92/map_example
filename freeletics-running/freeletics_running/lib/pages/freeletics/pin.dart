import 'package:flutter/material.dart';
import 'package:interpolate/interpolate.dart';
class Pin extends StatefulWidget {
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> scale;
  Interpolate ipOuterPin;
  Interpolate ipInPin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    Animation curve = CurvedAnimation(parent: _controller, curve: Curves.ease);
    scale = Tween<double>(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat(reverse: true);

    ipOuterPin=Interpolate(
      inputRange: [0, 1],
      outputRange: [20, 80],
      extrapolate: Extrapolate.clamp,
    );
    ipInPin=Interpolate(
      inputRange: [0, 1],
      outputRange: [10, 15],
      extrapolate: Extrapolate.clamp,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("scale.value " + scale.value.toString());
    final double sizeOuterPin=ipOuterPin.eval(scale.value);

    final double sizeInPin=ipInPin.eval(scale.value);
    return Container(
      height: sizeOuterPin,
      width: sizeOuterPin,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sizeOuterPin/2),
          color: Color.fromRGBO(233, 172, 71, 0.25)),
      child: Center(
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20/2), color: Colors.white),
          child: Center(
            child: Container(
              height: sizeInPin,
              width: sizeInPin,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sizeInPin/2),
                  color: Color.fromRGBO(233, 172, 71, 1)),
            ),
          ),
        ),
      ),
    );
  }
}
