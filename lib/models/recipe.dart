import 'package:abc_cooking/models/dish.dart';
import 'package:abc_cooking/models/ingredient.dart';

class Recipe {
  /*
  This class stores all the basic information about a recipe
  It is not meant for the graph of steps to be used while cooking
   */
  final String name;
  final int price;
  final bool veggie;
  final int healthy;
  final int prepTime;
  final int difficulty;
  final List<IngredientAmount> ingredients;
  final String pictureUrl;

  final Dish dish;

  final String id;

  Recipe(this.id, this.dish, this.name, this.price, this.veggie, this.healthy,
      this.prepTime,
      this.difficulty, this.ingredients, this.pictureUrl) : super();
}

class RecipeInstance {
  final Recipe recipe;
  final int persons;

  RecipeInstance(this.recipe, this.persons) : super();
}
