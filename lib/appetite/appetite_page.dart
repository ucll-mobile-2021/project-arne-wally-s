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
              () => _service.getRecommendedRecipes(),
              'Recommended',
              Icon(
                Icons.thumb_up,
                color: Colors.white,
                size: 70,
              ),
              'Recommended',
              Colors.green),
          getButton(
              context,
              () => _service.getPopularRecipes(),
              'Popular',
              Icon(
                Icons.star,
                color: Colors.white,
                size: 70,
              ),
              'Popular',
              Color.fromARGB(255, 218, 165, 32)),
          getButton(
              context,
              () => _service.getFavoriteRecipes(),
              'Favorites',
              Icon(
                Icons.favorite,
                color: Colors.white,
                size: 70,
              ),
              'My favorites',
              Colors.red),
          getButton(
              context,
              () => _service.getSurpriseRecipes(),
              'Surprises',
              Icon(
                Icons.redeem,
                color: Colors.white,
                size: 70,
              ),
              'Surprise me',
              Colors.deepPurple),
          getButton(
              context,
              () => _service.getBudgetRecipes(),
              'Budget recipes',
              Icon(
                Icons.local_atm,
                color: Colors.white,
                size: 70,
              ),
              'Budget',
              Colors.green[900]),
          getButton(
              context,
              () => _service.getTipRecipes(),
              'Tip from us',
              Icon(
                Icons.emoji_objects_outlined,
                color: Colors.white,
                size: 70,
              ),
              'Tip from us',
              Theme.of(context).primaryColor),
          getButton(
              context,
              () => _service.getVegetarianRecipes(),
              'Popular vegetarian',
              Icon(
                Icons.eco,
                color: Colors.white,
                size: 70,
              ),
              'Vegetarian',
              Colors.green),
          getButton(
              context,
              () => _service.getFishRecipes(),
              'Popular fish',
              Image.asset(
                'assets/fish_white.png',
                width: 58,
                height: 58,
              ),
              'Fish',
              Colors.blue),
          getButton(
              context,
              () => _service.getMeatRecipes(),
              'Popular meat',
              Icon(
                Icons.lunch_dining,
                color: Colors.white,
                size: 70,
              ),
              'Meat',
              Colors.red[900]),
          getButton(
              context,
              () => _service.getVeganRecipes(),
              'Popular vegan',
              Icon(
                Icons.grass,
                color: Colors.white,
                size: 70,
              ),
              'Vegan',
              Colors.green),
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

  Widget getButton(BuildContext context, Function func, String title,
      Widget child, String text, Color color) {
    return RaisedButton(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () async {
        var result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectRecipeWidget(title, func())));
        _selectRecipe(context, result);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          child,
          Text(
            text,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
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
    Scaffold.of(context).hideCurrentSnackBar();
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
