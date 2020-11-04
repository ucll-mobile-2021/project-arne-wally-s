import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/appetite_service.dart';
import 'package:abc_cooking/widgets/recipe_list.dart';
import 'package:flutter/material.dart';

class SearchRecipe extends SearchDelegate<Recipe> {
  final AppetiteService _service;
  bool fish = false;
  bool meat = false;
  bool veggie = false;
  bool vegan = false;

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
    var results = _service.getSearchResultsRecipes(query,
        fish: fish, meat: meat, veggie: veggie, vegan: vegan);
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ButtonBar(
          children: [
            RaisedButton(
              onPressed: () {
                fish = !fish;
                refreshResults(context);
              },
              child: Icon(Icons.waves),
              color: fish ? Colors.blue : null,
            ),
            RaisedButton(
              onPressed: () {
                meat = !meat;
                refreshResults(context);
              },
              child: Icon(Icons.lunch_dining),
              color: meat ? Colors.red[900] : null,
            ),
            RaisedButton(
              onPressed: () {
                veggie = !veggie;
                refreshResults(context);
              },
              child: Icon(Icons.eco),
              color: veggie ? Colors.green : null,
            ),
            RaisedButton(
              onPressed: () {
                vegan = !vegan;
                refreshResults(context);
              },
              child: Icon(Icons.grass),
              color: vegan ? Colors.green : null,
            ),
          ],
        ),
        RecipeList.function(results, (context, recipe) {
          close(context, recipe);
        }),
      ],
    ));
  }

  refreshResults(BuildContext context) {
    showSuggestions(context);
    showResults(context);
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
