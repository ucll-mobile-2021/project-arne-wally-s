import 'dart:async';

import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/widgets/camera_screen.dart';
import 'package:flutter/material.dart';

class CookDetailWidget extends StatefulWidget {
  final RecipeInstance _recipeInstance;

  CookDetailWidget(this._recipeInstance);

  @override
  _CookDetailWidgetState createState() => _CookDetailWidgetState();
}

class _CookDetailWidgetState extends State<CookDetailWidget> {
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

  double _timerCounter = 0.0;
  Timer _timer;

  void _startTimer(int number) {
    _timerCounter = number * 60.0;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerCounter > 0) {
          _timerCounter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.width,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(widget._recipeInstance.recipe.name,
                      style: TextStyle(color: Colors.white, shadows: [
                        Shadow(
                            // bottomLeft
                            offset: Offset(-.5, -.5),
                            color: Theme.of(context).primaryColor),
                        Shadow(
                            // bottomRight
                            offset: Offset(.5, -.5),
                            color: Theme.of(context).primaryColor),
                        Shadow(
                            // topRight
                            offset: Offset(.5, .5),
                            color: Theme.of(context).primaryColor),
                        Shadow(
                            // topLeft
                            offset: Offset(-.5, .5),
                            color: Theme.of(context).primaryColor),
                      ])),
                  background: Image.network(
                    widget._recipeInstance.recipe.picture,
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: SingleChildScrollView(
            child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Step ${widget._recipeInstance.recipe.steps[_counter].number}',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget._recipeInstance.recipe.steps[_counter].instructions}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget._recipeInstance.recipe.steps[_counter].timer_title != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    '${widget._recipeInstance.recipe.steps[_counter].timer_title}: ${widget._recipeInstance.recipe.steps[_counter].timer} min'),
                                Ink(
                                  decoration: const ShapeDecoration(
                                    color: Colors.deepOrange,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.alarm_add),
                                    color: Colors.white,
                                    onPressed: () {
                                      _startTimer(widget._recipeInstance.recipe.steps[_counter].timer);
                                      // TODO write Timer function to keep track of timers
                                    },
                                  ),
                                ),
                              ],
                            )
                          : null),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        _counter > 0
                            ? OutlineButton(
                                onPressed: _decrement,
                                padding: EdgeInsets.all(15),
                                textColor: Theme.of(context).primaryColor,
                                child: Text('Previous'),
                              )
                            : null,
                        _counter <
                                widget._recipeInstance.recipe.steps.length - 1
                            ? RaisedButton(
                                onPressed: _increment,
                                padding: EdgeInsets.all(15),
                                color: Theme.of(context).accentColor,
                                textColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                padding: EdgeInsets.all(15),
                                color: Theme.of(context).accentColor,
                                textColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                child: Text(
                                  'Finish',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        Text(
                            '${widget._recipeInstance.recipe.steps[_counter].number}/ ${widget._recipeInstance.recipe.steps.length}')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            widget._recipeInstance.recipe.steps[_counter].timer_title != null ?
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Timer'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                    child: Text('$_timerCounter / ${widget._recipeInstance.recipe.steps[_counter].timer}'),
                  ),
                ],
              ),
              )
            : SizedBox(),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CameraScreen()));
        },
      ),
    );
  }
}
