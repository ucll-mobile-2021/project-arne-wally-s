import 'dart:async';

import 'package:abc_cooking/cook/step_detail.dart';
import 'package:abc_cooking/cook/timer_page.dart';
import 'package:abc_cooking/cook/timer_widget.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:abc_cooking/services/timer_service.dart';
import 'package:abc_cooking/widgets/camera_screen.dart';
import 'package:abc_cooking/widgets/horizontal_dots.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class CookDetailWidget extends StatefulWidget {
  final RecipeInstance _recipeInstance;

  CookDetailWidget(this._recipeInstance);

  @override
  _CookDetailWidgetState createState() => _CookDetailWidgetState();
}

class _CookDetailWidgetState extends State<CookDetailWidget> {
  // Counter to keep track of recipes steps
  int _counter = 0;

  void _increment() {
    if (_counter < widget._recipeInstance.recipe.steps.length - 1)
      setState(() {
        _counter++;
      });
  }

  void _decrement() {
    if (_counter > 0) {
      setState(() {
        _counter--;
      });
    }
  }

  // Timer to check if there are any recipe timers that are done
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

  void _startTimer() {
    _countingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      var timerService = MyTimersService();
      if (timerService.myTimers.length > 0) {
        for (var timer in timerService.myTimers) {
          if (timer.timeLeftInSeconds() <= 0) {
            Vibration.vibrate();
            Future<AudioPlayer> playLocalAsset() async {
              AudioCache cache = new AudioCache();
              return await cache.play("microwave.wav");
            }
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Time!'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('${timer.title} is done!'),
                        Text('Be sure to check your food before continuing.'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Got it!'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
            timerService.removeTimer(timer);
          }
        }
      }
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyTimersService>(
        builder: (context, _myTimersService, child) {
      return Scaffold(
          appBar: AppBar(title: Text(widget._recipeInstance.recipe.name)),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: Image.network(
                      widget._recipeInstance.recipe.picture,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: PageController(initialPage: 0, keepPage: true),
                      children: List.generate(widget._recipeInstance.recipe.steps.length, (index) => StepDetail(widget._recipeInstance.recipe, index)),
                      onPageChanged: (index) {
                        setState(() {
                          _counter = index;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 2.5 - 26,),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      padding: EdgeInsets.all(18),
                      child: Text(
                        '${_counter + 1}/${widget._recipeInstance.recipe.steps.length}',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    HorizontalDots(widget._recipeInstance.recipe.steps.length, _counter),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: _myTimersService.myTimers.isEmpty
              ? null
              : FloatingActionButton(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.timer),
                      ),
                      Transform.translate(
                        offset: Offset(5, -5),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text('${_myTimersService.myTimers.length}'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TimerPage()));
                  },
                ));
    });
  }
}
