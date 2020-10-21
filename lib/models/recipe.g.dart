// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return Recipe(
    json['id'] as String,
    json['dish'] as String,
    json['name'] as String,
    json['price'] as int,
    json['veggie'] as bool,
    json['healthy'] as int,
    json['prep_time'] as int,
    json['difficulty'] as int,
    (json['ingredients'] as List)
        ?.map((e) => e == null
            ? null
            : Ingredientamount.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['picture'] as String,
    json['dishObject'] == null
        ? null
        : Dish.fromJson(json['dishObject'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'veggie': instance.veggie,
      'healthy': instance.healthy,
      'prep_time': instance.prep_time,
      'difficulty': instance.difficulty,
      'ingredients': instance.ingredients,
      'picture': instance.picture,
      'dish': instance.dish,
      'dishObject': instance.dishObject,
      'id': instance.id,
    };
