//import 'package:json_annotation/json_annotation.dart';
//part 'timer.g.dart';

//@JsonSerializable()
class Timer {
  String title;
  int minutes;

  Timer({this.title, this.minutes});
  //factory Timer.fromJson(Map<String, dynamic> json) => _$TimerFromJson(json);

  //Map<String, dynamic> toJson() => _$TimerToJson(this);
}