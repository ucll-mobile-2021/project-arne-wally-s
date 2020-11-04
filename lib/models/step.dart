import 'package:json_annotation/json_annotation.dart';

part 'step.g.dart';

@JsonSerializable()
class Step {
  /*
  This class stores all the information about a cooking step.
   */
  final int timer;
  final String timer_title;
  final String instructions;
  final int number;

  Step(this.timer, this.timer_title, this.instructions, this.number) : super();

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);

  Map<String, dynamic> toJson() => _$StepToJson(this);
}