import 'package:abc_cooking/cook/timer_page.dart';
import 'package:abc_cooking/cook/timer_widget.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/models/timer.dart';
import 'package:abc_cooking/services/timer_service.dart';
import 'package:abc_cooking/widgets/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Consumer<MyTimersService>(
        builder: (context, _myTimersService, child) {
      return Scaffold(
          appBar: AppBar(title: Text(widget._recipeInstance.recipe.name)),
          body: Stack(
            children: [
              Column(
                children: [
                  Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Step ${widget._recipeInstance.recipe.steps[_counter].number}/${widget._recipeInstance.recipe.steps.length}',
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
                            child: widget._recipeInstance.recipe.steps[_counter]
                                        .timer_title !=
                                    null
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                            setState(() {
                                              _myTimersService.addTimer(Timer(
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
                                      ),
                                    ],
                                  )
                                : null),
                      ],
                    ),
                  ),
                ],
              ),
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
                    _counter < widget._recipeInstance.recipe.steps.length - 1
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
                              child: Text('${_myTimersService.myTimers.length}'),
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
