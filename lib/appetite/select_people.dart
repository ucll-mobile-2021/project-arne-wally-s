import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/appetite_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          platesWidget,
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Row(
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
                  onPressed: people < 15
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
  Animation<double> _vibrateAnimation;
  Animation<double> _radiusPlate;
  Animation<double> _radiusTable;
  Random random = Random();

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

    _vibrateAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut)
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
          transform: Matrix4.skew(getRotation(_vibrateAnimation.value),
              getRotation(_vibrateAnimation.value))
            ..rotateX(pi / 4.5 + getRotation(_vibrateAnimation.value)),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 150),
                    blurRadius: 50,
                    spreadRadius: -10,
                    color: Colors.black87)
              ],
            ),
            child: CustomPaint(
              painter: PlatePainter(_radiusTable, _radiusPlate, plates: plates),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                width: 300,
                height: 300,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: _amountPlates == 2
                      ? Transform.translate(
                          offset: Offset(0, -35),
                          child: SizedBox(
                              child: Image(
                            image: AssetImage('assets/candle.png'),
                            width: 20,
                            height: 80,
                            fit: BoxFit.fill,
                          )),
                          key: ValueKey<int>(2),
                        )
                      : null,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  double getRotation(double value) {
    return sin(value * 4 * pi) / 30;
  }

  void setRadius(AnimationController controller) {
    var r = .65 + .012 * _amountPlates;
    Tween<double> tweenTable = Tween(begin: _radiusTable.value, end: r);
    _radiusTable = tweenTable.animate(controller)
      ..addListener(() {
        setState(() {});
      });
    var radius = min(r * pi / _amountPlates * .75, .28);
    Tween<double> tweenPlate = Tween(begin: _radiusPlate.value, end: radius);
    _radiusPlate = tweenPlate.animate(controller)
      ..addListener(() {
        setState(() {});
      });
    setState(() {});
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

    _vibrateAnimation = CurvedAnimation(parent: controller, curve: Curves.ease)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  void removePlate() {
    controller.dispose();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _amountPlates -= 1;

    plates.removeAt(random.nextInt(plates.length));

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

    _vibrateAnimation = CurvedAnimation(parent: controller, curve: Curves.ease)
      ..addListener(() {
        setState(() {});
      });
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
    var paint1 = Paint()
      ..color = Colors.brown[800]
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2 + 20), size.width / 2, paint1);
    var paint2 = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint2);

    var distanceFromCenter = radiusTable.value;
    var radius = radiusPlate.value * size.width / 2;
    var paintBottom = Paint()
      ..color = Color.fromARGB(255, 220, 220, 205)
      ..style = PaintingStyle.fill;
    var paintRim = Paint()
      ..color = Color.fromARGB(255, 240, 240, 230)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * .2;

    var paintRimRim = Paint()
      ..color = Color.fromARGB(255, 170, 170, 170)
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    for (var plate in plates) {
      Offset downCenter = Offset(
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
      canvas.drawCircle(downCenter, radius * .88, paintRimRim);
      var center = Offset(downCenter.dx, downCenter.dy - radius * .05);
      canvas.drawCircle(center, radius * .6, paintBottom);
      center = Offset(center.dx, center.dy - radius * .13);
      canvas.drawCircle(center, radius - paintRim.strokeWidth, paintRim);
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
