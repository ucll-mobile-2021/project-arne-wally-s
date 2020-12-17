import 'package:json_annotation/json_annotation.dart';

import 'ingredient.dart';

part 'ingredient_amount.g.dart';

@JsonSerializable()
class Ingredientamount {
  final Ingredient ingredient;
  final double amount;

  Ingredientamount(this.ingredient, this.amount) : super();

  factory Ingredientamount.fromJson(Map<String, dynamic> json) => _$IngredientamountFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientamountToJson(this);

  Map<String, dynamic> toMap() => {
    "amount":amount,
    "ingredientName": ingredient.name,
  };
}
