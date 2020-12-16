//import 'package:json_annotation/json_annotation.dart';
//part 'timer.g.dart';

//@JsonSerializable()
class Timer {
  String title;
  DateTime timeOfCreation;
  int durationInMinutes;
  int durationInSeconds;


  Timer({this.title, this.durationInMinutes}) {
    timeOfCreation = DateTime.now();
    durationInSeconds = durationInMinutes * 60;
  }

  int timeLeftInSeconds() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(timeOfCreation);
    int timeLeft = durationInSeconds - difference.inSeconds;
    return timeLeft;
  }
}