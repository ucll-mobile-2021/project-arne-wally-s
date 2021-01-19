import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/models/step.dart';
import 'package:abc_cooking/services/timer_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abc_cooking/models/timer.dart' as timerData;

class StepDetail extends StatelessWidget {
  final Recipe recipe;
  final int step;

  StepDetail(this.recipe, this.step);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Text(
              '${recipe.steps[step].instructions}',
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: recipe.steps[step].timer_title != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                            '${recipe.steps[step].timer_title}: ${recipe.steps[step].timer} min'),
                        RaisedButton(
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          child: Text('Start timer'),
                          onPressed: () {
                            var timerService =
                                Provider.of<MyTimersService>(context);
                            timerService.addTimer(timerData.Timer(
                                title: recipe.steps[step].timer_title,
                                durationInMinutes: recipe.steps[step].timer));
                          },
                        ),
                      ],
                    )
                  : null),
          SizedBox(
            height: 75,
          ),
          step == recipe.steps.length - 1
              ? RaisedButton(
                  onPressed: () {
                    var timerService = Provider.of<MyTimersService>(context);
                    timerService.removeAllTimers();
                    Navigator.of(context).pop(true);
                  },
                  padding: EdgeInsets.all(15),
                  color: Theme.of(context).accentColor,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Finish',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        Icon(Icons.arrow_right),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}
