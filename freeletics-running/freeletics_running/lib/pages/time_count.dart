import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TimeCount extends StatefulWidget {
  final bool complete;
  TimeCount({this.complete=false});
  @override
  _TimeCountState createState() => _TimeCountState();
}

class _TimeCountState extends State<TimeCount> {
  Timer _timer;

  DateTime _timeCount = new DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("TimeCount didChangeDependencies ");
  }

  @override
  void didUpdateWidget(covariant TimeCount oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("TimeCount didUpdateWidget ");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  void startTimer() {
    stopTimer();
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if(widget.complete==false)
          {
            setState(() {
              _timeCount=_timeCount.add(Duration(seconds: 1));
            });
          }
        else
          {
            stopTimer();
          }

      },
    );
  }

  void stopTimer(){
    _timer?.cancel();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_alarm,
          color: Colors.white,
          size: 18,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          DateFormat('mm:ss').format(_timeCount),
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }
}
