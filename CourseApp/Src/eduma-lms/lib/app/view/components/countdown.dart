import 'dart:async';
import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  final int duration;
  final Function callBack;

  const Countdown({super.key, required this.duration, required this.callBack});

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late Timer _timer;
  int _timeRemaining = 0;

  @override
  void initState() {

    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeRemaining = widget.duration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer.cancel();
          widget.callBack();
        }
      });
    });
  }

  String _formatTime(int time) {
    int house = time ~/ 3600;
    int minutes = (time % 3600) ~/ 60;
    int seconds = time % 60;
    String formattedTime = '';
    if(house > 0){
      formattedTime +='${house.toString().padLeft(2, '0')}:';
    }
    formattedTime +='${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(_timeRemaining),
      style: const TextStyle(
        color: Colors.red, fontFamily: "semibold"
      ),
    );
  }
}
