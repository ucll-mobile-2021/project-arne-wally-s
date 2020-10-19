// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dish _$DishFromJson(Map<String, dynamic> json) {
  return Dish(
    json['id'] as String,
    json['name'] as String,
    json['price'] as int,
    json['veggie'] as bool,
    json['healthy'] as int,
    json['prepTime'] as int,
    json['difficulty'] as int,
    json['pictureUrl'] as String,
  );
}

Map<String, dynamic> _$DishToJson(Dish instance) => <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'veggie': instance.veggie,
      'healthy': instance.healthy,
      'prepTime': instance.prepTime,
      'difficulty': instance.difficulty,
      'pictureUrl': instance.pictureUrl,
      'id': instance.id,
    };
