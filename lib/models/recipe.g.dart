// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return Recipe(
    json['id'] as String,
    json['dish'] == null
        ? null
        : Dish.fromJson(json['dish'] as Map<String, dynamic>),
    json['name'] as String,
    json['price'] as int,
    json['veggie'] as bool,
    json['healthy'] as int,
    json['prepTime'] as int,
    json['difficulty'] as int,
    (json['ingredients'] as List)
        ?.map((e) => e == null
            ? null
            : Ingredientamount.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['pictureUrl'] as String,
  );
}

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'veggie': instance.veggie,
      'healthy': instance.healthy,
      'prepTime': instance.prepTime,
      'difficulty': instance.difficulty,
      'ingredients': instance.ingredients,
      'pictureUrl': instance.pictureUrl,
      'dish': instance.dish,
      'id': instance.id,
    };
