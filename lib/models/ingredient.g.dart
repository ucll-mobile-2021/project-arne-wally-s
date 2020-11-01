// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return Ingredient(
    json['name'] as String,
    json['measurement_unit'] as String,
    json['type'] as String,
    (json['price'] as num)?.toDouble(),
    json['picture'] as String,
  );
}

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'measurement_unit': instance.measurement_unit,
      'type': instance.type,
      'price': instance.price,
      'picture': instance.picture,
    };
