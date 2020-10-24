import 'package:abc_cooking/appetite/search_recipe.dart';
import 'package:abc_cooking/appetite/search_speech_recipe.dart';
import 'package:abc_cooking/appetite/select_people.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/appetite_service.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:abc_cooking/widgets/recipe_list.dart';
import 'package:abc_cooking/widgets/recipe_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppetiteWidget extends StatelessWidget {
  final AppetiteService _service = AppetiteService();
  final Future<List<Recipe>> _futureRecommendedRecipes;

  AppetiteWidget()
      : _futureRecommendedRecipes = AppetiteService().getRecommendedRecipes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appetite'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _searchManually(context);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Recommended for you',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            buildRecommended(context),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mic),
        onPressed: () {
          _listenSpeech(context);
        },
      ),
    );
  }

  Widget buildRecommended(BuildContext context) {
    return RecipeList.function(_futureRecommendedRecipes, selectRecipe);
  }

  void selectRecipe(BuildContext context, Recipe recipe) {
    _selectRecipe(context, recipe, _service.getPeople());
  }

  void _selectRecipe(BuildContext context, Recipe recipe, int people) async {
    if (recipe != null) {
      var instance = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => SelectPeopleWidget(recipe)));
      if (instance != null) {
        var service = Provider.of<MyRecipesService>(context, listen: false);
        service.addRecipe(instance as RecipeInstance);

        final snackBar = SnackBar(
          content: Text('Recipe added to shopping list'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              service.removeRecipe(instance);
              final snack = SnackBar(
                content: Text('Recipe removed from shopping list'),
              );
              Scaffold.of(context).showSnackBar(snack);
            },
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }
  }

  void _listenSpeech(BuildContext context) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchRecipeSpeechWidget()));
    if (result != null) {
      var r = result as Recipe;
      _selectRecipe(context, r, _service.getPeople());
    }
  }

  void _searchManually(BuildContext context) async {
    _selectRecipe(
        context,
        await showSearch(context: context, delegate: SearchRecipe(_service)),
        _service.getPeople());
  }
}
