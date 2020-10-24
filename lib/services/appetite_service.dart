import 'dart:convert';
import 'dart:io';

import 'package:abc_cooking/models/recipe.dart';
import 'package:http/http.dart' as http;

class AppetiteService {
  static final AppetiteService _singleton = AppetiteService._internal();
  int _people = 1;

  factory AppetiteService() {
    return _singleton;
  }

  AppetiteService._internal();

  Future<List<Recipe>> getRecommendedRecipes() async {
    // TODO
    // Returns a list of recommended recipes
    return getSearchResultsRecipes('');
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

  Future<List<Recipe>> getSearchResultsRecipes(String query) async {
    var response = await http
        .get('https://abc-cooking.andreasmilants.com/recipes?search=$query');
    if (response.statusCode == 200) {
      return List.from(jsonDecode(response.body))
          .map((e) => Recipe.fromJson(e))
          .toList();
    }
    throw Exception('Failed to get recipes');
  }

  Future<List<Recipe>> getSearchFoodListResultsRecipes(
      List<String> food) async {
    var query = food.join(' ');
    return getSearchResultsRecipes(query);
  }

  int getPeople() {
    // Returns the default amount of people that should be filled in, if not yet specified
    // Probably makes the most sense to use the value of the last addition
    return _people;
  }

  void setPeople(int people) {
    _people = people;
  }

  Future<Map<String, dynamic>> watsonCall(String query) async {
    final response = await http
        .get('https://abc-cooking.andreasmilants.com/watson?question=$query');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Failed to connect to server");
  }
}
