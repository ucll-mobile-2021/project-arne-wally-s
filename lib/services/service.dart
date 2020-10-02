import 'dart:collection';

import 'package:abc_cooking/models/dish.dart';
import 'package:abc_cooking/models/ingredient.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:flutter/material.dart';

class MyRecipesService extends ChangeNotifier {
  List<RecipeInstance> _myRecipes;

  UnmodifiableListView<RecipeInstance> get myRecipes =>
      UnmodifiableListView(_myRecipes);

  MyRecipesService() : super() {
    this._myRecipes = [
      RecipeInstance(
          Recipe(
            '1',
            Dish('1', 'Spaghetti', 1, false, 3, 1, 1, ''),
            'Jeroen Meus',
            1,
            false,
            3,
            1,
            1,
            [
              IngredientAmount(Ingredient('Tomato', '', 'vegetable', 0.5, ''), 2),
              IngredientAmount(Ingredient('Carrot', '', 'vegetable', 0.5, ''), 1),
              IngredientAmount(Ingredient('Minced meat', 'kg', 'meat', 2, ''), .3),
            ],
            'https://www.okokorecepten.nl/i/recepten/kookboeken/2014/new-york-recepten-big-apple/spaghetti-meatballs-500.jpg',
          ),
          1),
    ];
  }

  void addRecipe(RecipeInstance recipe) {
    _myRecipes.add(recipe);
    notifyListeners();
  }

  void removeRecipe(RecipeInstance recipe) {
    _myRecipes.remove(recipe);
    notifyListeners();
  }
}
