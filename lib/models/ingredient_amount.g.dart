// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_amount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredientamount _$IngredientamountFromJson(Map<String, dynamic> json) {
  return Ingredientamount(
    json['ingredient'] == null
        ? null
        : Ingredient.fromJson(json['ingredient'] as Map<String, dynamic>),
    (json['amount'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$IngredientamountToJson(Ingredientamount instance) =>
    <String, dynamic>{
      'ingredient': instance.ingredient,
      'amount': instance.amount,
    };
