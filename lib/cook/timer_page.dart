import 'package:abc_cooking/cook/timer_widget.dart';
import 'package:abc_cooking/services/timer_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timers'),
      ),
      body: Consumer<MyTimersService>(
          builder: (context, service, child) {
        if (service.myTimers.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo_pan.png'),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                    'There are no more timers. Go back and continue with the next step.',
                    style:
                        TextStyle(fontSize: 17, fontStyle: FontStyle.italic)),
              ),
            ],
          );
        }
        return ListView.builder(
          itemCount: service.myTimers.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              child: TimerWidget(service.myTimers[i]),
              onLongPress: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Remove timer'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Are you sure you want to remove this timer?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            service.removeTimerAt(i);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      }),
    );
  }
}
