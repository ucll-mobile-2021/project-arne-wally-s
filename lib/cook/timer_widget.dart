import 'dart:async';

import 'package:abc_cooking/models/timer.dart' as timerData;
import 'package:abc_cooking/services/timer_service.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final timerData.Timer _timer;

  TimerWidget(this._timer);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _counter;
  Timer _countingTimer;
  MyTimersService _timersService = MyTimersService();

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _countingTimer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _counter = widget._timer.durationInSeconds - widget._timer.timeLeftInSeconds();
    if (_countingTimer != null) {
      _countingTimer.cancel();
    }
    _countingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter < widget._timer.durationInSeconds) {
          _counter++;
        } else {
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Time!'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('${widget._timer.title} is done!'),
                      Text('Be sure to check you food before continuing.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Got it!'),
                    onPressed: () {
                      _timersService.removeTimer(widget._timer);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          _countingTimer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${widget._timer.title}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$_counter / ${widget._timer.durationInSeconds}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _counter == widget._timer.durationInSeconds ?
            Text(
              'Finished!',
              style: TextStyle(color: Colors.green),
            ) :
            Text(
              'In progress!'
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
            child: LinearProgressIndicator(
              value: _counter / (widget._timer.durationInSeconds),
              backgroundColor: Colors.grey[700],
            ),
          )
        ],
      ),
    );
  }
}
