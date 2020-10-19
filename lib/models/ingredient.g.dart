// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return Ingredient(
    json['name'] as String,
    json['measurementUnit'] as String,
    json['type'] as String,
    (json['price'] as num)?.toDouble(),
    json['pictureUrl'] as String,
  );
}

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'measurementUnit': instance.measurementUnit,
      'type': instance.type,
      'price': instance.price,
      'pictureUrl': instance.pictureUrl,
    };
