import 'dart:collection';
import 'package:abc_cooking/models/recipe.dart';
import 'package:flutter/material.dart';

class MyRecipesService extends ChangeNotifier {
  /*
  This service should save things to the database and is available everywhere
   */
  List<RecipeInstance> _myRecipes = [];

  UnmodifiableListView<RecipeInstance> get myRecipes =>
      UnmodifiableListView(_myRecipes);

  MyRecipesService() : super() {
    //TODO load myrecipes from sqlite
  }

  void addRecipe(RecipeInstance recipe) {
    _myRecipes.add(recipe);
    //TODO add recipe to sqlite

    print(_myRecipes);
    notifyListeners();
  }

  void removeRecipe(RecipeInstance recipe) {
    _myRecipes.remove(recipe);
    //TODO remove recipe in sqlite

    notifyListeners();
  }
}
