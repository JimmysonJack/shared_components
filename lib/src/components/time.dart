import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Time extends StatefulWidget {
  const Time({super.key});

  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> {
  DateTime time = DateTime.now();
  void handleTick() {
    setState(() {
      time = DateTime.now();
    });
  }

  late Timer timer;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      handleTick();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        '${DateFormat('dd MMM').format(time)} ${DateFormat('y').format(time).substring(2)} ${DateFormat('HH:mm:ss').format(time)}');
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
