import 'dart:async';

import 'package:abc_cooking/cook/timer_page.dart';
import 'package:abc_cooking/cook/timer_widget.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/models/timer.dart' as timerData;
import 'package:abc_cooking/services/service.dart';
import 'package:abc_cooking/services/timer_service.dart';
import 'package:abc_cooking/widgets/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

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
          for ( var timer in timerService.myTimers) {
            if (timer.timeLeftInSeconds() <= 0) {
              Vibration.vibrate();
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
        };
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
            SingleChildScrollView(
              child: Column(
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Step ${widget._recipeInstance.recipe.steps[_counter].number}/${widget._recipeInstance.recipe.steps.length}',
                          style: Theme.of(context).textTheme.headline.merge(TextStyle(fontSize: 30)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Text(
                          '${widget._recipeInstance.recipe.steps[_counter].instructions}',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: widget._recipeInstance.recipe.steps[_counter]
                                      .timer_title !=
                                  null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                        '${widget._recipeInstance.recipe.steps[_counter].timer_title}: ${widget._recipeInstance.recipe.steps[_counter].timer} min'),
                                    RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      textColor: Colors.white,
                                      child: Text('Start timer'),
                                      onPressed: () {
                                        setState(() {
                                          _myTimersService.addTimer(timerData.Timer(
                                              title: widget
                                                  ._recipeInstance
                                                  .recipe
                                                  .steps[_counter]
                                                  .timer_title,
                                              durationInMinutes: widget
                                                  ._recipeInstance
                                                  .recipe
                                                  .steps[_counter]
                                                  .timer));
                                        });
                                      },
                                    ),
                                  ],
                                )
                              : null),
                    ],
                  ),
                  SizedBox(
                    height: 75,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  _counter > 0
                      ? RaisedButton(
                          onPressed: _decrement,
                          padding: EdgeInsets.all(15),
                          color: Colors.white,
                          textColor: Theme.of(context).primaryColor,
                          child: Row(
                            children: [
                              Icon(Icons.arrow_left),
                              Text('Previous', style: TextStyle(fontSize: 17),),
                            ],
                          ),
                        )
                      : null,
                  _counter < widget._recipeInstance.recipe.steps.length - 1
                      ? RaisedButton(
                          onPressed: _increment,
                          padding: EdgeInsets.all(15),
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).colorScheme.onSecondary,
                          child: Row(
                            children: [
                              Text(
                                'Next',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17
                                ),
                              ),
                              Icon(Icons.arrow_right),
                            ],
                          ),
                        )
                      : RaisedButton(
                          onPressed: () {
                            _myTimersService.removeAllTimers();
                            Navigator.of(context).pop(true);
                          },
                          padding: EdgeInsets.all(15),
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).colorScheme.onSecondary,
                          child: Row(
                            children: [
                              Text(
                                'Finish',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17
                                ),
                              ),
                              Icon(Icons.arrow_right),
                            ],
                          ),
                        ),
                ],
              ),
            )
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
                      child: Text(
                          '${_myTimersService.myTimers.length}'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TimerPage()));
          },
        )
      );
    });
  }
}
