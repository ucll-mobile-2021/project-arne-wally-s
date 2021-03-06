import 'package:abc_cooking/appetite/select_recipe_page.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/appetite_service.dart';
import 'package:abc_cooking/widgets/recipe_detail.dart';
import 'package:abc_cooking/widgets/recipe_list.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SearchRecipe extends SearchDelegate<RecipeInstance> {
  final AppetiteService _service;
  bool fish = false;
  bool meat = false;
  bool veggie = false;
  bool vegan = false;
  bool drink = false;
  bool dessert = false;
  bool alcohol = false;
  bool food = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


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
          dessert: dessert,
          alcohol: alcohol);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // drink? alcoholic : fish, meat, veggie, vegan
          drink || dessert || food ?
            drink ?
              ButtonBar(
                      buttonPadding: EdgeInsets.zero,
                      alignment: MainAxisAlignment.end,
                      children: [
                        // Drink
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
                                  alcohol = false;

                                });
                              },
                              child: Icon(
                                Icons.liquor,
                                color: drink ? Colors.white : null,
                              ),
                              color: drink ? Colors.black : null,
                            ),
                          ),
                        ),

                        // Alcohol
                        Tooltip(
                          message: 'Alcohol',
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  alcohol = !alcohol;
                                });
                              },
                              child: Icon(
                                Icons.local_bar,
                                color: alcohol ? Colors.white : null,
                              ),
                              color: alcohol ? Colors.red : null,
                            ),
                          ),
                        ),
                      ],
                    )
              : food ?
                ButtonBar(
                      buttonPadding: EdgeInsets.zero,
                      alignment: MainAxisAlignment.end,
                      children: [
                        // Food, fish, meat, vegan, veggie
                        Tooltip(
                          message: 'Food',
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  food = !food;
                                });
                              },
                              child: Icon(
                                Icons.food_bank,
                                color: food ? Colors.white : null,
                              ),
                              color: food ? Colors.orange[900] : null,
                            ),
                          ),
                        ),
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
                                  alcohol = false;

                                });
                              },
                              child: Image.asset(
                                fish ? 'assets/fish_white.png' : 'assets/fish.png',
                                width: 19,
                                height: 19,
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
                                  alcohol = false;

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
                                  alcohol = false;

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
                                  alcohol = false;

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
                    )

                : ButtonBar(
                        buttonPadding: EdgeInsets.zero,
                        alignment: MainAxisAlignment.end,
                        children: [
                          // dessert, alcohol
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
                                    alcohol = false;

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
                          Tooltip(
                            message: 'Alcohol',
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    alcohol = !alcohol;
                                  });
                                },
                                child: Icon(
                                  Icons.local_bar,
                                  color: alcohol ? Colors.white : null,
                                ),
                                color: alcohol ? Colors.red : null,
                              ),
                            ),
                          ),
                        ],
          )

          :
          // drink, food, dessert
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
                        alcohol = false;

                      });
                    },
                    child: Icon(
                      Icons.liquor,
                      color: drink ? Colors.white : null,
                    ),
                    color: drink ? Colors.black : null,
                  ),
                ),
              ),
              Tooltip(
                message: 'Food',
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        food = !food;
                      });
                    },
                    child: Icon(
                      Icons.food_bank,
                      color: food ? Colors.white : null,
                    ),
                    color: food ? Colors.orange[900] : null,
                  ),
                ),
              ),
              // Desserts
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
                        alcohol = false;

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
          RecipeList.function(results, (thisContext, recipe) async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => RecipeDetailWidget.select(recipe, true)));
            if (result != null) {
              // You should not try to understand this
              close(MyApp.navigatorKey.currentContext, result);
            }
          }, subtrHeight: 175,),
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
