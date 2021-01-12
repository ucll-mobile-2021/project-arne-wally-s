import 'package:abc_cooking/models/recipe.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show utf8;

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
    Widget img;
    if (_width != 0) {
      img = FadeInImage.assetNetwork(
        image: _recipe.picture,
        placeholder: 'assets/logo_pan.png',
        height: _width,
      );
    } else {
      img = FadeInImage.assetNetwork(
        image: _recipe.picture,
        placeholder: 'assets/logo_pan.png',
      );
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
