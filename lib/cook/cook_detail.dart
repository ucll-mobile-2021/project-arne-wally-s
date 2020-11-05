import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/models/step.dart' as RecipeStep;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery
                    .of(context)
                    .size
                    .width,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    title: Text(widget._recipeInstance.recipe.name,
                        style: TextStyle(color: Colors.white, shadows: [
                          Shadow(
                            // bottomLeft
                              offset: Offset(-.5, -.5),
                              color: Theme
                                  .of(context)
                                  .primaryColor),
                          Shadow(
                            // bottomRight
                              offset: Offset(.5, -.5),
                              color: Theme
                                  .of(context)
                                  .primaryColor),
                          Shadow(
                            // topRight
                              offset: Offset(.5, .5),
                              color: Theme
                                  .of(context)
                                  .primaryColor),
                          Shadow(
                            // topLeft
                              offset: Offset(-.5, .5),
                              color: Theme
                                  .of(context)
                                  .primaryColor),
                        ])),
                    background: Image.network(
                      widget._recipeInstance.recipe.picture,
                      fit: BoxFit.cover,
                    )),
              ),
            ];
          },
          body: SingleChildScrollView(
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Step ${widget._recipeInstance.recipe.steps[_counter]
                            .number}',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${widget._recipeInstance.recipe.steps[_counter]
                            .instructions}',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline6,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget._recipeInstance.recipe.steps[_counter].timer_title != null ?
                      TimerWidget(widget._recipeInstance.recipe.steps[_counter]) :
                      null ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        _counter > 0
                            ? OutlineButton(
                          onPressed: _decrement,
                          padding: EdgeInsets.all(15),
                          textColor: Theme
                              .of(context)
                              .primaryColor,
                          child: Text('Previous'),
                        )
                            : null,
                        _counter <
                            widget._recipeInstance.recipe.steps.length - 1
                            ? RaisedButton(
                          onPressed: _increment,
                          padding: EdgeInsets.all(15),
                          color: Theme
                              .of(context)
                              .accentColor,
                          textColor: Theme
                              .of(context)
                              .colorScheme
                              .onSecondary,
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
                          color: Theme
                              .of(context)
                              .accentColor,
                          textColor: Theme
                              .of(context)
                              .colorScheme
                              .onSecondary,
                          child: Text(
                            'Finish',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                            '${widget._recipeInstance.recipe.steps[_counter]
                                .number}/ ${widget._recipeInstance.recipe.steps
                                .length}')
                      ],
                    ),
                  ],
                ),
              )),
        ));
  }
}

class TimerWidget extends StatelessWidget {
  final RecipeStep.Step _step;

  TimerWidget(this._step);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('${_step.timer_title}: ${_step.timer} min'),
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.deepOrange,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(Icons.alarm_add),
            color: Colors.white,
            onPressed: () {
              // TODO write Timer function to keep track of timers
            },
          ),
        ),
      ],
    );
  }
}
