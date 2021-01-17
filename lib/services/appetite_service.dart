import 'dart:convert';
import 'dart:io';

import 'package:abc_cooking/DB/DB.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:http/http.dart' as http;

class AppetiteService {
  static final AppetiteService _singleton = AppetiteService._internal();
  int _people = 1;

  factory AppetiteService() {
    return _singleton;
  }

  AppetiteService._internal();

  Future<List<Recipe>> getRecipesFromUrl(String url) async {
    var response =
        await http.get(url);
    if (response.statusCode == 200) {
      return List.from(jsonDecode(response.body)['results'])
          .map((e) => Recipe.fromJson(e))
          .toList();
    }
    throw Exception('Failed to get recipes');
  }

  Future<List<Recipe>> getRecommendedRecipes() async {
    var usedRecipes = await RecipeHelper().usedRecipes();
    print("used recipes id's: " + usedRecipes.toString());
    var myJson = jsonEncode(usedRecipes).toString();
    // Returns a list of recommended recipes
    return getRecipesFromUrl('https://abc-cooking.andreasmilants.com/recommended/?recipes=$myJson');
  }

  Future<List<Recipe>> getPopularRecipes() async {
    return getRecipesFromUrl('https://abc-cooking.andreasmilants.com/random/');
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    var usedRecipes = await RecipeHelper().usedRecipes();
    print("used recipes id's: " + usedRecipes.toString());
    var myJson = jsonEncode(usedRecipes).toString();
    return getRecipesFromUrl('https://abc-cooking.andreasmilants.com/get-recipes/?recipes=$myJson');
  }

  Future<List<Recipe>> getSurpriseRecipes() async {
    return getRecipesFromUrl('https://abc-cooking.andreasmilants.com/random/');
  }

  Future<List<Recipe>> getBudgetRecipes() async {
    return getRecipesFromUrl('https://abc-cooking.andreasmilants.com/budget/');
  }

  Future<List<Recipe>> getTipRecipes() async {
    return getRecipesFromUrl('https://abc-cooking.andreasmilants.com/tip/');
  }

  Future<List<Recipe>> getVegetarianRecipes() async {
    return getSearchResultsRecipes('', veggie: true);
  }

  Future<List<Recipe>> getFishRecipes() async {
    return getSearchResultsRecipes('', fish: true);
  }

  Future<List<Recipe>> getMeatRecipes() async {
    return getSearchResultsRecipes('', meat: true);
  }

  Future<List<Recipe>> getVeganRecipes() async {
    return getSearchResultsRecipes('', vegan: true);
  }

  Future<List<Recipe>> getDrinkRecipes() async {
    return getSearchResultsRecipes('', drink: true);
  }

  Future<List<Recipe>> getDessertRecipes() async {
    return getSearchResultsRecipes('', dessert: true);
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
    List<String> suggestions = [];
    return suggestions;
  }

  Future<List<String>> getSearchSuggestionsEmpty() async {
    var recipes = await RecipeHelper().recipes();
    return List.generate(recipes.length, (index) => recipes[index].name);
  }

  Future<List<Recipe>> getSearchResultsRecipes(String query,
      {bool vegan: false,
      bool veggie: false,
      bool meat: false,
      bool fish: false,
      bool drink: false,
      bool dessert: false}) async {
    var qS = '?search=$query&vegan=$vegan&veggie=$veggie&meat=$meat&fish=$fish&drink=$drink&dessert=$dessert';
    return getRecipesFromUrl('https://abc-cooking.andreasmilants.com/recipes$qS');
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
