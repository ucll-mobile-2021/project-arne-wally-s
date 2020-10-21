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
        await http.get('https://jsonplaceholder.typicode.com/albums/');
    //var json = response.body;
    var json = '''[
    {
      "name": "Spaghetti Jeroen Meus",
    "price": 2,
    "veggie": false,
    "healthy": 3,
    "prepTime": 1,
    "difficulty": 2,
    "ingredients": [
    ],
    "pictureUrl": "https://www.okokorecepten.nl/i/recepten/kookboeken/2014/new-york-recepten-big-apple/spaghetti-meatballs-500.jpg",
    "dish": null,
    "id": "1"
    }
    ]''';
    if (response.statusCode == 200) {
      return List.from(jsonDecode(json))
          .map((e) => Recipe.fromJson(e))
          .toList();
    }
    throw Exception('Failed to get recipes');
  }
}
