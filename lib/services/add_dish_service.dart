import 'dart:convert';

import 'package:abc_cooking/models/dish.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:http/http.dart' as http;

class AddDishService {
  static final AddDishService _singleton = AddDishService._internal();

  factory AddDishService() {
    return _singleton;
  }

  AddDishService._internal();

  List<Dish> getRecommended() {
    // TODO
    // Returns a list of recommended dishes
    return [];
  }

  List<String> getSearchSuggestions(String query) {
    // TODO
    // Returns a list of suggestions while searching
    // Example: query = 's' -> return ['Spaghetti', 'Salad']
    List<String> suggestions = ['Spaghetti', 'Pizza', 'Lasagne'];
    return suggestions;
  }

  List<String> getSearchSuggestionsEmpty() {
    // TODO
    // Returns a list of search suggestions when nothing is typed yet
    // Could be popular items or recent searches
    return ['Caesar salad', 'Balletjes in tomatensaus'];
  }

  List<Dish> getSearchDishResults(String query) {
    // TODO
    // Returns dishes that match your search
    List<Dish> results = [
      Dish('id', 'Spaghetti', 1, false, 3, 10, 1,
          'https://www.leukerecepten.nl/wp-content/uploads/2019/06/spaghetti-bolognese_v.jpg'),
    ];
    return results;
  }

  int getPeople() {
    // Returns the default amount of people that should be filled in, if not yet specified
    // Probably makes the most sense to use the value of the last addition
    return 1;
  }

  Future<List<Recipe>> getRecipesForDish(Dish dish) async {
    // TODO
    final response =
        await http.get('https://jsonplaceholder.typicode.com/albums/');
    if (response.statusCode == 200) {
      return [];
    }
    throw Exception('Failed to get recipes');
  }
}
