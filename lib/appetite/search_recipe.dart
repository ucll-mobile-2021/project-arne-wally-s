import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/appetite_service.dart';
import 'package:abc_cooking/widgets/recipe_list.dart';
import 'package:flutter/material.dart';

class SearchRecipe extends SearchDelegate<Recipe> {
  final AppetiteService _service;

  SearchRecipe(this._service);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    var results = _service.getSearchResultsRecipes(query);
    return SingleChildScrollView(
        child: RecipeList.function(results, (context, recipe) {
          close(context, recipe);
        }));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Future<List<String>> suggestions;
    // If we haven't put anything in yet, we suggest recent or popular searches
    query.isEmpty
        ? suggestions = _service.getSearchSuggestionsEmpty()
        : suggestions = _service.getSearchSuggestions(query);
    return FutureBuilder(
        future: suggestions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data[index]),
                    onTap: () {
                      query = snapshot.data[index];
                      showResults(context);
                    },
                  );
                });
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
