import 'package:json_annotation/json_annotation.dart';

import 'ingredient_amount.dart';
import 'step.dart';
import 'package:uuid/uuid.dart';
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
  final bool vegan;
  final int healthy;
  final int prep_time;
  final int difficulty;
  final List<Ingredientamount> ingredients;
  final List<Step> steps;
  final String picture;
  final String id;

  Recipe(this.id, this.name, this.price, this.veggie,this.vegan, this.healthy,
      this.prep_time, this.difficulty, this.ingredients, this.steps, this.picture)
      : super();

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  @override
  String toString() {
    return 'Recipe{name: $name, price: $price, veggie: $veggie, healthy: $healthy, difficulty: $difficulty, picture: $picture, id: $id}';
  } //"name": name,
  //"veggie": veggie,
  /*

   */

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "price": price,
    "veggie": (veggie)? 1 : 0,
    "vegan": (vegan)? 1 : 0,
    "healthy": healthy,
    "prep_time": prep_time,
    "difficulty": difficulty,
    "picture": picture,
  };



}

class RecipeInstance {
  final Recipe recipe;
  final int persons;
  var uuid;

  RecipeInstance(this.recipe, this.persons) : super(){
    this.uuid =  Uuid().v4();
  }
  RecipeInstance.fromDB(this.recipe, this.persons,this.uuid) : super();

  @override
  String toString() {
    return '${recipe.name} - $persons';
  }

  Map<String, dynamic> toJson(RecipeInstance instance) => <String, dynamic>{
    'uuid': instance.uuid,
    'recipeid': instance.recipe.id,
    'persons': instance.persons,
  };

}




