import 'package:abc_cooking/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;
  final Function tapAction;

  RecipeWidget(this.recipe) : tapAction = null;
  RecipeWidget.tap(this.recipe, this.tapAction);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Column(
          children: [
            Image.network(recipe.picture),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    recipe.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        if (tapAction != null) {
          tapAction();
        }
      },
    );
  }
}
