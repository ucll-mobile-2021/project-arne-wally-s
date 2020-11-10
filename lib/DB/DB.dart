// Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
import 'package:abc_cooking/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class RecipeHelper{
  static Database _database;
  static RecipeHelper _recipeHelper;

  final String tableName = "recipe";
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
  Future<Database>initializeDatabase() async{
    var dir = await getDatabasesPath();
    var path = dir + "recipe.db";
    var database = openDatabase(path, version: 1,onCreate: (db,version){
      // , name TEXT
      //veggie BOOLEAN,
      //, veggie INTEGER
      //
      db.execute('''
      CREATE TABLE $tableName(id TEXT PRIMARY KEY, name TEXT, price INTEGER,veggie INTEGER, healthy INTEGER, prep_time INTEGER, difficulty INTEGER,picture TEXT)''');
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
          maps[i]['healthy'],
          maps[i]['prep_time'],
          maps[i]['difficulty'],
          null,
          null,
          maps[i]['picture']
      );
      print("##################################################");
      print(recipe1.toString());
      print(recipe1.price);
      return recipe1;
    });
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
