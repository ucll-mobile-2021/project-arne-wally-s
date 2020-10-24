import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/appetite_service.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class SelectPeopleWidget extends StatefulWidget {
  final Recipe recipe;

  SelectPeopleWidget(this.recipe);

  @override
  State<StatefulWidget> createState() {
    return _SelectPeopleState();
  }
}

class _SelectPeopleState extends State<SelectPeopleWidget> {
  int people;
  PlatesWidget platesWidget;

  @override
  void initState() {
    super.initState();
    people = AppetiteService().getPeople();
    platesWidget = PlatesWidget(
      startPlates: people,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          platesWidget,
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlineButton(
                child: Icon(Icons.remove),
                onPressed: people > 1
                    ? () {
                        setState(() {
                          people -= 1;
                          platesWidget.removePlate();
                        });
                      }
                    : null,
              ),
              const SizedBox(
                width: 12,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 2)],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    people.toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              OutlineButton(
                child: Icon(Icons.add),
                onPressed: people < 30
                    ? () {
                        setState(() {
                          people += 1;
                          platesWidget.addPlate();
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () {
              // Set default people to latest used value
              AppetiteService().setPeople(people);
              Navigator.pop(context, RecipeInstance(widget.recipe, people));
            },
            padding: EdgeInsets.all(15),
            color: Theme.of(context).accentColor,
            textColor: Theme.of(context).colorScheme.onSecondary,
            child: Text(
              'ADD TO SHOPPING LIST',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          OutlineButton(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.all(15),
            textColor: Theme.of(context).primaryColor,
            child: Text('CANCEL'),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class PlatesWidget extends StatefulWidget {
  final int startPlates;
  _PlatesState state;

  PlatesWidget({this.startPlates: 1});

  @override
  State<StatefulWidget> createState() {
    state = _PlatesState(startPlates);
    return state;
  }

  void addPlate() {
    state.addPlate();
  }

  void removePlate() {
    state.removePlate();
  }
}

class _PlatesState extends State<PlatesWidget> with TickerProviderStateMixin {
  List<Plate> plates = [];
  AnimationController controller;
  Animation<double> _radiusPlate;
  Animation<double> _radiusTable;

  int _amountPlates;

  _PlatesState(this._amountPlates);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    var arcSize = 2 * pi / _amountPlates;
    var startTheta = 0.0;
    for (var i = 0; i < _amountPlates; i++) {
      Tween<double> tweenTheta = Tween(begin: startTheta, end: startTheta);
      var animationTheta = tweenTheta.animate(controller)
        ..addListener(() {
          setState(() {});
        });

      plates.add(Plate(animationTheta));
      startTheta += arcSize;
    }
    var r = .7 + .006 * _amountPlates;
    Tween<double> tweenTable = Tween(begin: r, end: r);
    _radiusTable = tweenTable.animate(controller)
      ..addListener(() {
        setState(() {});
      });
    var radius = min(r * pi / _amountPlates * .75, .2);
    Tween<double> tweenPlate = Tween(begin: radius, end: radius);
    _radiusPlate = tweenPlate.animate(controller)
      ..addListener(() {
        setState(() {});
      });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.skew(0, 0)..rotateX(pi/2.75),
          child: CustomPaint(
            foregroundPainter:
                PlatePainter(_radiusTable, _radiusPlate, plates: plates),
            child: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
              width: 300,
              height: 300,
            ),
          ),
        )
      ],
    );
  }

  void setRadius(AnimationController controller) {
    var r = .7 + .006 * _amountPlates;
    Tween<double> tweenTable = Tween(begin: _radiusTable.value, end: r);
    _radiusTable = tweenTable.animate(controller)
      ..addListener(() {
        setState(() {});
      });
    var radius = min(r * pi / _amountPlates * .75, .2);
    Tween<double> tweenPlate = Tween(begin: _radiusPlate.value, end: radius);
    _radiusPlate = tweenPlate.animate(controller)
      ..addListener(() {
        setState(() {});
      });
    setState(() {});
    print(_radiusTable);
  }

  void addPlate() {
    controller.dispose();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _amountPlates += 1;
    var arcSize = 2 * pi / _amountPlates;
    var startTheta = arcSize;
    for (var plate in plates) {
      Tween<double> tweenTheta =
          Tween(begin: plate.animationTheta.value, end: startTheta);
      var animationTheta = tweenTheta.animate(controller)
        ..addListener(() {
          setState(() {});
        });
      plate.animationTheta = animationTheta;
      startTheta += arcSize;
    }

    Tween<double> tweenTheta = Tween(begin: 2 * pi, end: 2 * pi);
    var animationTheta = tweenTheta.animate(controller)
      ..addListener(() {
        setState(() {});
      });
    plates.add(Plate(animationTheta));
    setRadius(controller);
    setState(() {});
    controller.forward();
  }

  void removePlate() {
    controller.dispose();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _amountPlates -= 1;
    var arcSize = 2 * pi / _amountPlates;
    var startTheta = 0.0;
    for (var plate in plates) {
      Tween<double> tweenTheta =
          Tween(begin: plate.animationTheta.value, end: startTheta);
      var animationTheta = tweenTheta.animate(controller)
        ..addListener(() {
          setState(() {});
        });
      plate.animationTheta = animationTheta;
      startTheta += arcSize;
    }
    plates.removeAt(plates.length - 1);
    setRadius(controller);
    setState(() {});
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class PlatePainter extends CustomPainter {
  final List<Plate> plates;
  final Animation<double> radiusPlate;
  final Animation<double> radiusTable;

  PlatePainter(
    this.radiusTable,
    this.radiusPlate, {
    this.plates: const [],
  });

  @override
  void paint(Canvas canvas, Size size) {
    var distanceFromCenter = radiusTable.value;
    var radius = radiusPlate.value * size.width / 2;

    var paintCenter = Paint()
      ..color = Colors.grey[300]
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    var paintRim = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    for (var plate in plates) {
      Offset center = Offset(
          size.width / 2 +
              size.width *
                  distanceFromCenter /
                  2 *
                  cos(plate.animationTheta.value - pi / 2),
          size.height / 2 +
              size.height *
                  distanceFromCenter /
                  2 *
                  sin(plate.animationTheta.value - pi / 2));
      canvas.drawCircle(center, radius, paintRim);
      canvas.drawCircle(center, radius * .75, paintCenter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    for (var plate in plates) {
      if (!plate.animationTheta.isCompleted) {
        return true;
      }
    }
    return false;
  }
}

class Plate {
  Animation<double> animationTheta;

  Plate(this.animationTheta);
}
