// Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
import 'package:abc_cooking/models/ingredient.dart';
import 'package:abc_cooking/models/ingredient_amount.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/models/timer.dart';
import 'package:abc_cooking/models/step.dart' as im;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class RecipeHelper{
  static Database _database;
  static RecipeHelper _recipeHelper;

  final String recipeTableName = "recipe";
  RecipeHelper._createInstance();
  factory RecipeHelper(){
    if(_recipeHelper == null){
      _recipeHelper = RecipeHelper._createInstance();
    }
    return _recipeHelper;
  }


  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }
  Future<Database>initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "recipe.db";
    var database = await openDatabase(path, version: 1,onCreate: (db,version){
      db.execute('''
      CREATE TABLE recipe(id TEXT, name TEXT, price INTEGER,veggie INTEGER, healthy INTEGER, prep_time INTEGER, difficulty INTEGER,picture TEXT)''');
      db.execute('''
      CREATE TABLE step(timer INTEGER, number INTEGER, instructions TEXT,timer_title TEXT)''');
      db.execute('''
      CREATE TABLE timer(minutes INTEGER, title TEXT)''');
      db.execute('''
      CREATE TABLE ingredient_amount(double REAL, ingredient TEXT, REFERENCES recipe(id))''');
      db.execute('''
      CREATE TABLE cart(double REAL, ingredient TEXT, REFERENCES recipe(id))''');

  },);


    return database;
  }

  Future<List<Recipe>> recipes() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('recipe');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      var recipe1 =Recipe(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['price'],
          (maps[i]['veggie']==0)? false : true,
          (maps[i]['vegan']==0)? false : true,
          maps[i]['healthy'],
          maps[i]['prep_time'],
          maps[i]['difficulty'],
          null,
          null,
          maps[i]['picture']
      );
      print(recipe1.toString());
      print(recipe1.price);
      return recipe1;
    });
  }

  void insertStep(im.Step step) async{
    var db = await this.database;
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(step.toJson().toString());
    var result = await db.insert("step", step.toJson());

    print('result: $result');
  }

  void insertIngredient(Ingredient ingredient) async{
    var db = await this.database;
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(ingredient.toJson().toString());
    var result = await db.insert("ingredient", ingredient.toJson());

    print('result: $result');
  }
  void insertIngredientAmount(Ingredientamount ingredientamount) async{
    var db = await this.database;
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(ingredientamount.toJson().toString());
    var result = await db.insert("ingredient", ingredientamount.toJson());
    print('result: $result');
  }

  void insertRecipe(Recipe recipe) async{
    var db = await this.database;
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(recipe.toJson().toString());

    print("____________________________");
    recipes().toString();
    print("____________________________");

    var result = await db.insert("recipe", recipe.toMap());

    print('result: $result');
  }

  Future<void> deleteRecipe(String id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the Database.
    await db.delete(
      'recipe',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
