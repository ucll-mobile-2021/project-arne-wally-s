import 'package:abc_cooking/cook/timer_widget.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/models/timer.dart';
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
  List<Timer> timers = [];

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
        body: Column(
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
                                  setState(() {
                                    timers.add(Timer(title: widget._recipeInstance.recipe.steps[_counter].timer_title, minutes: widget._recipeInstance.recipe.steps[_counter].timer));
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      : null),
              ButtonBar(
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
            ],
          ),
        ),
        timers.length > 0 ?
        Expanded(
          child: ListView.builder(
            itemCount: timers.length,
            itemBuilder: (context, i) {
                return GestureDetector(
                    child: TimerWidget(timers[i].minutes, timers[i].title),
                    onLongPress: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Remove timer?'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('Are you sure you want to remove this timer?'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  setState(() {
                                    timers.removeAt(i);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    },);
              },
              ),
        )
        : SizedBox(),
          ],
        ),
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
