// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return Recipe(
    json['id'] as String,
    json['name'] as String,
    json['price'] as int,
    json['veggie'] as bool,
    json['vegan'] as bool,
    json['healthy'] as int,
    json['prep_time'] as int,
    json['difficulty'] as int,
    (json['ingredients'] as List)
        ?.map((e) => e == null
            ? null
            : Ingredientamount.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['steps'] as List)
        ?.map(
            (e) => e == null ? null : Step.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['picture'] as String,
  );
}

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'veggie': instance.veggie,
      'vegan': instance.vegan,
      'healthy': instance.healthy,
      'prep_time': instance.prep_time,
      'difficulty': instance.difficulty,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
      'picture': instance.picture,
      'id': instance.id,
    };
