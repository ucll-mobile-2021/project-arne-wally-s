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

  Future<List<Recipe>> getPopularRecipes() async {
    // TODO
    return getSearchResultsRecipes('');
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    // TODO
    return getSearchResultsRecipes('');
  }

  Future<List<Recipe>> getSurpriseRecipes() async {
    // TODO
    return getSearchResultsRecipes('');
  }

  Future<List<Recipe>> getBudgetRecipes() async {
    // TODO
    return getSearchResultsRecipes('');
  }

  Future<List<Recipe>> getTipRecipes() async {
    // TODO
    return getSearchResultsRecipes('');
  }

  Future<List<Recipe>> getVegetarianRecipes() async {
    // TODO
    return getSearchResultsRecipes('', veggie: true);
  }

  Future<List<Recipe>> getFishRecipes() async {
    // TODO
    return getSearchResultsRecipes('', fish: true);
  }

  Future<List<Recipe>> getMeatRecipes() async {
    // TODO
    return getSearchResultsRecipes('', meat: true);
  }

  Future<List<Recipe>> getVeganRecipes() async {
    // TODO
    return getSearchResultsRecipes('', vegan: true);
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    // Returns a list of suggestions while searching
    var response = await http.get(
        'https://abc-cooking.andreasmilants.com/autocomplete?search=$query');
    if (response.statusCode == 200) {
      return List.from(jsonDecode(response.body))
          .map((e) => e.toString())
          .toList();
    }
    print('error');
    print(response.body);
    List<String> suggestions = [];
    return suggestions;
  }

  Future<List<String>> getSearchSuggestionsEmpty() async {
    // TODO
    // Returns a list of search suggestions when nothing is typed yet
    // Could be popular items or recent searches
    return [];
  }

  Future<List<Recipe>> getSearchResultsRecipes(String query,
      {bool vegan: false,
      bool veggie: false,
      bool meat: false,
      bool fish: false}) async {
    var qS =
        '?search=$query&vegan=$vegan&veggie=$veggie&meat=$meat&fish=$fish';
    var response =
        await http.get('https://abc-cooking.andreasmilants.com/recipes$qS');
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
