import 'package:abc_cooking/cook/cook_detail.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CookWidget extends StatefulWidget {
  @override
  _CookWidgetState createState() => _CookWidgetState();
}

class _CookWidgetState extends State<CookWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cook'),
      ),
      body: Column(
        children: [
          Consumer<MyRecipesService>(builder: (context, service, child) {
            var _recipes = service.myRecipes;
            if (_recipes.length > 0) {
              return Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemCount: _recipes.length,
                      itemBuilder: (context, i) {
                        return ListWidget(_recipes[i]);
                      }));
            }
            else {
              return Center(
                child: Text(
                  "You have to add a recipe before you can start cooking!"
                ),
              );
            }
          })
        ],
      ),
    );
  }
}

class ListWidget extends StatelessWidget {
  final RecipeInstance _recipeInstance;

  ListWidget(this._recipeInstance);

  @override
  Widget build(BuildContext context) {
    Image img = Image.network(_recipeInstance.recipe.picture);

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
    );
  }
}

void cookDetail(BuildContext context, RecipeInstance recipeInstance) async {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CookDetailWidget(recipeInstance)));
}

