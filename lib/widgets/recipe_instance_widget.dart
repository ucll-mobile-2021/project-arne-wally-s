import 'package:abc_cooking/cook/cook_detail.dart';
import 'package:abc_cooking/cook/finished.dart';
import 'package:abc_cooking/main.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeInstanceWidget extends StatelessWidget {
  final RecipeInstance _recipeInstance;
  final double _width;

  RecipeInstanceWidget(this._recipeInstance) : _width = 0;

  RecipeInstanceWidget.width(this._recipeInstance, this._width);

  @override
  Widget build(BuildContext context) {
    Widget img;
    if (_width != 0) {
      img = FadeInImage.assetNetwork(
        image: _recipeInstance.recipe.picture,
        placeholder: 'assets/placeholder.png',
        height: _width,
      );
    } else {
      img = FadeInImage.assetNetwork(
        image: _recipeInstance.recipe.picture,
        placeholder: 'assets/placeholder.png',
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
                    _recipeInstance.recipe.name,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        cookDetail(context, _recipeInstance);
      },
      onLongPress: () {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Remove recipe'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'Do you want to remove this recipe from your cooking list?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    var service =
                        Provider.of<MyRecipesService>(context, listen: false);
                    service.removeRecipe(_recipeInstance);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

void cookDetail(BuildContext context, RecipeInstance recipeInstance) async {
  MyHomePageState.scaffoldKey.currentState.hideCurrentSnackBar();
  if (recipeInstance.recipe.steps.length > 0) {
    var finished = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CookDetailWidget(recipeInstance)));
    if (finished != null && finished) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => FinishedPage()));
    }
  } else {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Whoops!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'It seems like this recipe has no instructions. This problem has been reported to our support team.'),
                Text('Sorry for the inconvenience!')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                var service =
                    Provider.of<MyRecipesService>(context, listen: false);
                service.removeRecipe(recipeInstance);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
