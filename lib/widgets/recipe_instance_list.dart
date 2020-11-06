import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/widgets/recipe_instance_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeInstanceList extends StatelessWidget {
  final List<RecipeInstance> _recipeInstances;

  RecipeInstanceList(this._recipeInstances);

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
                child: RecipeInstanceWidget.width(item, w),
              );
            })
                .toList()
                .cast<Widget>(),
          );
        });
  }
}
