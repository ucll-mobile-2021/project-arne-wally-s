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

  Future<List<Dish>> getRecommended() async {
    // TODO
    // Returns a list of recommended dishes
    return [];
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    // TODO
    // Returns a list of suggestions while searching
    // Example: query = 's' -> return ['Spaghetti', 'Salad']
    List<String> suggestions = ['Spaghetti', 'Pizza', 'Lasagne'];
    return suggestions;
  }

  Future<List<String>> getSearchSuggestionsEmpty() async {
    // TODO
    // Returns a list of search suggestions when nothing is typed yet
    // Could be popular items or recent searches
    return ['Caesar salad', 'Balletjes in tomatensaus'];
  }

  Future<List<Dish>> getSearchDishResults(String query) async {
    // TODO
    // Returns dishes that match your search
    List<Dish> results = [
      Dish('id', 'Spaghetti', 1, false, 3, 10, 1,
          'https://www.leukerecepten.nl/wp-content/uploads/2019/06/spaghetti-bolognese_v.jpg'),
    ];
    return results;
  }

  Future<List<Dish>> getDishResultsFromFoodList(List<String> food) async {
    var response =
        await http.get('https://abc-cooking.andreasmilants.com/dishes');
    if (response.statusCode == 200) {
      return List.from(jsonDecode(response.body))
          .map((e) => Dish.fromJson(e))
          .toList();
    }
    throw Exception('Failed to get recipes');
  }

  int getPeople() {
    // Returns the default amount of people that should be filled in, if not yet specified
    // Probably makes the most sense to use the value of the last addition
    return 1;
  }

  Future<Map<String, dynamic>> watsonCall(String query) async {
    final response = await http
        .get('https://abc-cooking.andreasmilants.com/watson?question=$query');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Failed to connect to server");
  }

  Future<List<Recipe>> getRecipesForDish(Dish dish) async {
    final response =
        await http.get('https://abc-cooking.andreasmilants.com/recipes');
    var json = response.body;
    print(json);
    if (response.statusCode == 200) {
      return List.from(jsonDecode(json))
          .map((e) => Recipe.fromJson(e))
          .toList();
    }
    throw Exception('Failed to get recipes');
  }
}
