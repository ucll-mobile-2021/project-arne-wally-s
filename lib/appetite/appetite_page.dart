import 'dart:math';

import 'package:abc_cooking/appetite/search_recipe.dart';
import 'package:abc_cooking/appetite/search_speech_recipe.dart';
import 'package:abc_cooking/appetite/select_recipe_page.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/appetite_service.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:abc_cooking/widgets/recipe_detail.dart';
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
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        padding: EdgeInsets.all(15),
        children: [
          getButton(
              context,
              _service.getRecommendedRecipes(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.thumb_up,
                    color: Colors.green,
                    size: 70,
                  ),
                  Text('Recommended for me'),
                ],
              ),
              'Recommended'),
          getButton(
              context,
              _service.getPopularRecipes(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Transform.rotate(
                    angle: -pi / 10,
                    child: Icon(
                      Icons.star,
                      size: 70,
                      color: Color.fromARGB(255, 218, 165, 32),
                    ),
                  ),
                  Text('Popular'),
                ],
              ),
              'Popular'),
          getButton(
              context,
              _service.getFavoriteRecipes(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 70,
                  ),
                  Text('My Favorites'),
                ],
              ),
              'Favorites'),
          getButton(
              context,
              _service.getSurpriseRecipes(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.redeem,
                    size: 70,
                    color: Colors.deepPurple,
                  ),
                  Text('Surprise me'),
                ],
              ),
              'Surprises'),
          getButton(
              context,
              _service.getBudgetRecipes(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.local_atm,
                    size: 70,
                    color: Colors.green[900],
                  ),
                  Text('Budget'),
                ],
              ),
              'Budget recipes'),
          getButton(
              context,
              _service.getTipRecipes(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.emoji_objects_outlined,
                    size: 70,
                    color: Colors.deepOrange,
                  ),
                  Text('Tip from us'),
                ],
              ),
              'Tip from us'),
          getButton(
              context,
              _service.getVegetarianRecipes(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.eco,
                    size: 70,
                    color: Colors.green,
                  ),
                  Text('Popular vegetarian'),
                ],
              ),
              'Popular vegetarian'),
          getButton(
              context,
              _service.getFishRecipes(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.waves,
                    size: 70,
                    color: Colors.blue,
                  ),
                  Text('Popular fish'),
                ],
              ),
              'Popular fish'),
          getButton(
              context,
              _service.getMeatRecipes(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.lunch_dining,
                    size: 70,
                    color: Colors.red[900],
                  ),
                  Text('Popular meat'),
                ],
              ),
              'Popular meat'),
          getButton(
              context,
              _service.getVeganRecipes(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.grass,
                    size: 70,
                    color: Colors.green,
                  ),
                  Text('Popular vegan'),
                ],
              ),
              'Popular vegan'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mic),
        onPressed: () {
          _listenSpeech(context);
        },
      ),
    );
  }

  Widget getButton(BuildContext context, Future<List<Recipe>> recipes,
      Widget child, String title) {
    return OutlineButton(
      color: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () async {
        var result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectRecipeWidget(title, recipes)));
        _selectRecipe(context, result);
      },
      child: child,
    );
  }

  void selectRecipe(BuildContext context, Recipe recipe) async {
    _selectRecipe(
        context,
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RecipeDetailWidget.select(recipe, true))));
  }

  void _selectRecipe(BuildContext context, RecipeInstance recipe) {
    if (recipe != null) {
      var service = Provider.of<MyRecipesService>(context, listen: false);
      service.addRecipe(recipe);

      final snackBar = SnackBar(
        content: Text('Recipe added to shopping list'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            service.removeRecipe(recipe);
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

  void _listenSpeech(BuildContext context) async {
    _selectRecipe(
        context,
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchRecipeSpeechWidget())));
  }

  void _searchManually(BuildContext context) async {
    var recipe =
        await showSearch(context: context, delegate: SearchRecipe(_service));
    if (recipe != null) {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RecipeDetailWidget.select(recipe, true)));
      if (result != null) {
        _selectRecipe(context, result);
      }
    }
  }
}
