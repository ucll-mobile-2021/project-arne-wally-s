import 'package:abc_cooking/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeWidget extends StatelessWidget {
  final Recipe _recipe;
  final Function _tapAction;
  final double _width;

  RecipeWidget(this._recipe)
      : _tapAction = null,
        _width = 0;

  RecipeWidget.tap(this._recipe, this._tapAction) : _width = 0;

  RecipeWidget.width(this._recipe, this._tapAction, this._width);

  @override
  Widget build(BuildContext context) {
    Image img;
    if (_width != 0) {
      img = Image.network(
        _recipe.picture,
        height: _width,
      );
    } else {
      img = Image.network(_recipe.picture);
    }

    return GestureDetector(
      child: Card(
        child: Column(
          children: [
            img,
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
