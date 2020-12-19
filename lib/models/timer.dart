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
  Timer timerConstructor(String title, int durationInMinutes,String timeOfCreation ){
    var temp = Timer(title: title,durationInMinutes: durationInMinutes);
    temp.timeOfCreation = DateTime.parse(timeOfCreation);
    return temp;
  }

  Timer fromJson(Map<String, dynamic> json) {
    var timeOfCreation= json['timeOfCreation'];
    var title = json['title'];
    var durationInMinutes =json['durationInMinutes'];
    var durationInSeconds = json['durationInSeconds'];
    return timerConstructor(title, durationInMinutes, timeOfCreation);
  }

  Map<String, dynamic> toJson(Timer instance) => <String, dynamic>{
    'title': instance.title,
    'timeOfCreation': instance.timeOfCreation.toString(),
    'durationInMinutes': instance.durationInMinutes,
    'durationInSeconds': instance.durationInSeconds,
  };

}