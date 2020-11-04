import 'package:json_annotation/json_annotation.dart';

import 'ingredient_amount.dart';
import 'step.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  /*
  This class stores all the basic information about a recipe
  It is not meant for the graph of steps to be used while cooking
   */
  final String name;
  final int price;
  final bool veggie;
  final int healthy;
  final int prep_time;
  final int difficulty;
  final List<Ingredientamount> ingredients;
  final List<Step> steps;
  final String picture;


  final String id;

  Recipe(this.id, this.name, this.price, this.veggie, this.healthy,
      this.prep_time, this.difficulty, this.ingredients, this.steps, this.picture)
      : super();

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}

class RecipeInstance {
  final Recipe recipe;
  final int persons;

  RecipeInstance(this.recipe, this.persons) : super();

  @override
  String toString() {
    return '${recipe.name} - $persons';
  }
}
