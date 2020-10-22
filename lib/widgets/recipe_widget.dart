import 'package:abc_cooking/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeWidget extends StatelessWidget {
  Recipe _recipe;
  Function _tapAction;

  RecipeWidget(this._recipe);
  RecipeWidget.tap(this._recipe, this._tapAction);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Column(
          children: [
            Image.network(_recipe.picture),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    _recipe.name,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        if (_tapAction != null) {
          _tapAction();
        }
      },
    );
  }
}
