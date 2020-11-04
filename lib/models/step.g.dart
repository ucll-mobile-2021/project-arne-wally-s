// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Step _$StepFromJson(Map<String, dynamic> json) {
  return Step(
    json['timer'] as int,
    json['timer_title'] as String,
    json['instructions'] as String,
    json['number'] as int,
  );
}

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
      'timer': instance.timer,
      'timer_title': instance.timer_title,
      'instructions': instance.instructions,
      'number': instance.number,
    };
