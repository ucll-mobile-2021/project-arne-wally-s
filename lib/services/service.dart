import 'dart:collection';
import 'package:abc_cooking/models/cart.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:flutter/material.dart';

class MyRecipesService extends ChangeNotifier {
  List<RecipeInstance> _myRecipes = [];
  Cart cart = Cart();  // This should be saved to the database. It takes care of this itself

  UnmodifiableListView<RecipeInstance> get myRecipes =>
      UnmodifiableListView(_myRecipes);

  MyRecipesService() : super();

  void addRecipe(RecipeInstance recipe) {
    _myRecipes.add(recipe);
    cart.addRecipe(recipe);
    notifyListeners();
  }

  void removeRecipe(RecipeInstance recipe) {
    _myRecipes.remove(recipe);
    cart.removeRecipe(recipe);
    notifyListeners();
  }

  void deleteSelected() {
    var recipes = cart.getSelected();
    for (var recipe in recipes) {
      removeRecipe(recipe);
    }
    cart.deleteSelected();
    notifyListeners();
  }

  bool empty() {
    return cart.recipes.length == 0;
  }
}
