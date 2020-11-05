import 'package:abc_cooking/widgets/recipe_detail.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/widgets/recipe_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeInstanceList extends StatelessWidget {
  final List<RecipeInstance> _recipeInstances;
  Function _function;

  RecipeInstanceList(this._recipeInstances, bool shouldReturnRecipeInstance) {
    if (shouldReturnRecipeInstance) {
      this._function = returnRecipe;
    } else {
      _function = null;
    }
  }

  RecipeInstanceList.function(this._recipeInstances, this._function);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery
        .of(context)
        .size
        .width * 0.5 - 2.5;
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, i) {
          return Wrap(
            spacing: 5,
            runSpacing: 5,
            children: _recipeInstances
                .map((item) {
              return Container(
                width: w,
                child: RecipeWidget.width(
                    item.recipe,
                    _function != null
                        ? () {
                      Function.apply(_function, [context, item]);
                    }
                        : null,
                    w),
              );
            })
                .toList()
                .cast<Widget>(),
          );
        });
  }

  void returnRecipe(BuildContext context, Recipe recipe) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeDetailWidget.select(recipe, true)));
    if (result != null) {
      Navigator.pop(context, result);
    }
  }
}
