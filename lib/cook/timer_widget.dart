import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final int _timerCounter;
  final String _timerTitle;

  TimerWidget(this._timerCounter, this._timerTitle);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _counter;
  Timer _timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _counter = 0;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter < widget._timerCounter * 60) {
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
                      Text('${widget._timerTitle} is done!'),
                      Text('Be sure to check you food before continuing.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Got it!'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          _timer.cancel();
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
            child: Text('${widget._timerTitle}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$_counter / ${widget._timerCounter * 60}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _counter == widget._timerCounter * 60 ?
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
              value: _counter / (widget._timerCounter * 60.0),
              backgroundColor: Colors.grey[700],
            ),
          )
        ],
      ),
    );
  }
}
