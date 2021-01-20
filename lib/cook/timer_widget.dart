import 'dart:async';

import 'package:abc_cooking/models/timer.dart' as timerData;
import 'package:abc_cooking/services/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerWidget extends StatefulWidget {
  final timerData.Timer _timer;

  TimerWidget(this._timer);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _counter;
  Timer _countingTimer;

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

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("microwave.mp3");
  }

  void _startTimer() {
    _counter =
        widget._timer.durationInSeconds - widget._timer.timeLeftInSeconds();
    if (_countingTimer != null) {
      _countingTimer.cancel();
    }
    _countingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter < widget._timer.durationInSeconds) {
          _counter++;
        } else {
          Vibration.vibrate();
          playLocalAsset();
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
                      Text('Be sure to check your food before continuing.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Consumer<MyTimersService>(builder: (context, service, child) {
                    return TextButton(
                      child: Text('Got it!'),
                      onPressed: () {
                        service.removeTimer(widget._timer);
                        Navigator.of(context).pop();
                      },
                    );
                  }),
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
    var left = Duration(seconds: widget._timer.durationInSeconds - _counter);
    var goal = Duration(seconds: widget._timer.durationInSeconds);
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${widget._timer.title}', style: Theme.of(context).textTheme.headline5,),
          ),
          SizedBox(height: 30,),
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(0, 10),
                  child: CircularProgressIndicator(
                    value: _counter / (widget._timer.durationInSeconds),
                    backgroundColor: Colors.grey[300],
                    strokeWidth: 60,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(0, -10),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: EdgeInsets.all(30),
                    child: Text(
                      '${durationToTime(left)}',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  String durationToTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    if (duration.inHours >= 1) {
      return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
    }
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}
