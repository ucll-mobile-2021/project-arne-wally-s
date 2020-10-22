import 'package:abc_cooking/appetite/search_recipe.dart';
import 'package:abc_cooking/appetite/search_speech_recipe.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/appetite_service.dart';
import 'package:abc_cooking/widgets/recipe_widget.dart';
import 'package:flutter/material.dart';

class AppetiteWidget extends StatelessWidget {
  final AppetiteService service = AppetiteService();
  final Future<List<Recipe>> futureRecipes;

  AppetiteWidget() : futureRecipes = AppetiteService().getSearchResultsRecipes('');


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
      body: Column(
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mic),
        onPressed: () {
          _listenSpeech(context);
        },
      ),
    );
  }

  Widget buildRecommended(BuildContext context) {
    return FutureBuilder(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
              spacing: 5,
              runSpacing: 5,
              children: snapshot.data.map((item) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.5 - 2.5,
                  child: RecipeWidget.tap(item, () {
                    _selectRecipe(context, item, service.getPeople());
                  }),
                );
              }).toList().cast<Widget>(),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  void _selectRecipe(BuildContext context, Recipe recipe, int people) async {
    if (recipe != null) {
    }
  }

  void _listenSpeech(BuildContext context) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchRecipeSpeechWidget()));
    if (result != null) {
      var r = result as Recipe;
      _selectRecipe(
          context, r, service.getPeople());
    }
  }

  void _searchManually(BuildContext context) async {
    _selectRecipe(
        context,
        await showSearch(context: context, delegate: SearchRecipe(service)),
        service.getPeople());
  }
}
