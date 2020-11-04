import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/widgets/recipe_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectRecipeWidget extends StatelessWidget {
  final String _title;
  final Future<List<Recipe>> _recipes;

  SelectRecipeWidget(this._title, this._recipes);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title),),
      body: RecipeList(_recipes, true),
    );
  }

}