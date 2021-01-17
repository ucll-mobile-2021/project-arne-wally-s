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
  bool drink = false;
  bool dessert = false;

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
    return SingleChildScrollView(child:
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      var results = _service.getSearchResultsRecipes(query,
          fish: fish,
          meat: meat,
          veggie: veggie,
          vegan: vegan,
          drink: drink,
          dessert: dessert);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // drink? alcoholic : fish, meat, veggie, vegan
          drink
              ? ButtonBar(
                  buttonPadding: EdgeInsets.zero,
                  alignment: MainAxisAlignment.end,
                  children: [
                    // TODO alcoholic filter
                    // Drinks
                    Tooltip(
                      message: 'Drink',
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              drink = !drink;
                              vegan = false;
                              meat = false;
                              veggie = false;
                              fish = false;
                              dessert = false;
                            });
                          },
                          child: Icon(
                            Icons.local_bar,
                            color: drink ? Colors.white : null,
                          ),
                          color: drink ? Colors.black : null,
                        ),
                      ),
                    ),
                    // Deserts
                    Tooltip(
                      message: 'Dessert',
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              dessert = !dessert;
                              vegan = false;
                              meat = false;
                              veggie = false;
                              fish = false;
                              drink = false;
                            });
                          },
                          child: Icon(
                            Icons.cake,
                            color: dessert ? Colors.white : null,
                          ),
                          color: dessert ? Colors.brown[800] : null,
                        ),
                      ),
                    ),
                  ],
                )
              : ButtonBar(
                  buttonPadding: EdgeInsets.zero,
                  alignment: MainAxisAlignment.end,
                  children: [
                    Tooltip(
                      message: 'Fish',
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              fish = !fish;
                              meat = false;
                              veggie = false;
                              vegan = false;
                              drink = false;
                              dessert = false;
                            });
                          },
                          child: Image.asset(
                            fish ? 'assets/fish_white.png' : 'assets/fish.png',
                            width: 21,
                            height: 21,
                          ),
                          color: fish ? Colors.blue : null,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: 'Meat',
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              meat = !meat;
                              fish = false;
                              veggie = false;
                              vegan = false;
                              drink = false;
                              dessert = false;
                            });
                          },
                          child: Icon(
                            Icons.lunch_dining,
                            color: meat ? Colors.white : null,
                          ),
                          color: meat ? Colors.red[900] : null,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: 'Vegetarian',
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              veggie = !veggie;
                              meat = false;
                              fish = false;
                              vegan = false;
                              drink = false;
                              dessert = false;
                            });
                          },
                          child: Icon(
                            Icons.eco,
                            color: veggie ? Colors.white : null,
                          ),
                          color: veggie ? Colors.green : null,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: 'Vegan',
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              vegan = !vegan;
                              meat = false;
                              veggie = false;
                              fish = false;
                              drink = false;
                              dessert = false;
                            });
                          },
                          child: Icon(
                            Icons.grass,
                            color: vegan ? Colors.white : null,
                          ),
                          color: vegan ? Colors.green : null,
                        ),
                      ),
                    ),
                  ],
                ),

          // drink, dessert
          ButtonBar(
            alignment: MainAxisAlignment.end,
            buttonPadding: EdgeInsets.zero,
            children: [
              // Drinks
              Tooltip(
                message: 'Drink',
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        drink = !drink;
                        vegan = false;
                        meat = false;
                        veggie = false;
                        fish = false;
                        dessert = false;
                      });
                    },
                    child: Icon(
                      Icons.local_bar,
                      color: drink ? Colors.white : null,
                    ),
                    color: drink ? Colors.black : null,
                  ),
                ),
              ),
              // Deserts
              Tooltip(
                message: 'Dessert',
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        dessert = !dessert;
                        vegan = false;
                        meat = false;
                        veggie = false;
                        fish = false;
                        drink = false;
                      });
                    },
                    child: Icon(
                      Icons.cake,
                      color: dessert ? Colors.white : null,
                    ),
                    color: dessert ? Colors.brown[800] : null,
                  ),
                ),
              ),
            ],
          ),

          RecipeList.function(
            results,
            (context, recipe) {
              close(context, recipe);
            },
            subtrHeight: 175,
          ),
        ],
      );
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
