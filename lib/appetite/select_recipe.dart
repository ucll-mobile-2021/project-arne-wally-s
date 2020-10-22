import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/widgets/recipe_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectRecipeWidget extends StatelessWidget {
  final Future<List<Recipe>> _futureRecipes;

  SelectRecipeWidget(this._futureRecipes);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
              spacing: 5,
              runSpacing: 5,
              children: snapshot.data.map((item) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.5 - 2.5,
                  child: RecipeWidget.tap(item, () {
                    Navigator.pop(context, item);
                  }),
                );
              }).toList().cast<Widget>(),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
