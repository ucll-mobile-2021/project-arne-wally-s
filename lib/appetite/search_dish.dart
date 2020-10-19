import 'package:abc_cooking/models/dish.dart';
import 'package:abc_cooking/services/add_dish_service.dart';
import 'package:abc_cooking/widgets/dish.dart';
import 'package:flutter/material.dart';

class SearchDish extends SearchDelegate<Dish> {
  final AddDishService service;

  SearchDish(this.service);

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
    var results = service.getSearchDishResults(query);
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return DishWidget.tap(results[index], () {
            close(context, results[index]);
          });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions;
    // If we haven't put anything in yet, we suggest recent or popular searches
    query.isEmpty
        ? suggestions = service.getSearchSuggestions(query)
        : suggestions = service.getSearchSuggestionsEmpty();
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestions[index]),
            onTap: () {
              query = suggestions[index];
              showResults(context);
            },
          );
        });
  }
}
