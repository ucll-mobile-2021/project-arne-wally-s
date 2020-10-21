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
    return FutureBuilder(
        future: results,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return DishWidget.tap(snapshot.data[index], () {
                    close(context, snapshot.data[index]);
                  });
                });
          }
          return CircularProgressIndicator();
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Future<List<String>> suggestions;
    // If we haven't put anything in yet, we suggest recent or popular searches
    query.isEmpty
        ? suggestions = service.getSearchSuggestions(query)
        : suggestions = service.getSearchSuggestionsEmpty();
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
        return CircularProgressIndicator();
      }
    );
  }
}
