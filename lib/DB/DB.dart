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
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }
  Future<Database>initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "recipe.db";
    /*
    var db1 = await openDatabase(path, version: 1,onCreate: (db,version){
      db.execute('''
      CREATE TABLE ingredient(name TEXT , measurement_unit TEXT ,type TEXT , price REAL , picture TEXT)''');
    },);
    */


    var database = await openDatabase(path,onConfigure: _onConfigure ,version: 1,onCreate: (db,version){
      db.execute('''
      CREATE TABLE ingredient(name TEXT PRIMARY KEY, measurement_unit TEXT,type TEXT, price REAL, picture TEXT)''');
      db.execute('''
      CREATE TABLE recipe(id TEXT, name TEXT, price INTEGER,veggie INTEGER, healthy INTEGER, prep_time INTEGER, difficulty INTEGER,picture TEXT)''');
      db.execute('''
      CREATE TABLE step(timer INTEGER, number INTEGER, instructions TEXT,timer_title TEXT)''');
      db.execute('''
      CREATE TABLE timer(minutes INTEGER, title TEXT)''');
      db.execute('''
      CREATE TABLE ingredient_amount(amount REAL, ingredientName TEXT , FOREIGN KEY(ingredientName) REFERENCES ingredient(name))''');
     /*
      db.execute('''
      CREATE TABLE cart(double REAL, ingredient TEXT, REFERENCES recipe(id))''');*/

  },);




    return database;
  }

  Future<List<Recipe>> recipes() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipe');
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
      return recipe1;
    });
  }
  Future<List<Ingredient>> ingredients() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ingredient');
    var ingredients = List.generate(maps.length, (i) {
      var ingredient =Ingredient(
          maps[i]['name'],
          maps[i]['measurement_unit'],
          maps[i]['type'],
          maps[i]['price'],
          maps[i]['picture']
      );
    });
    return ingredients;
  }

  Future<Ingredient> getIngredient(String name) async {
    // Get a reference to the database.
    final Database db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
          'ingredient', where: "name = '$name' ");
      var ingredients = List.generate(maps.length, (i) {
        var ingredient = Ingredient(
            maps[i]['name'],
            maps[i]['measurement_unit'],
            maps[i]['type'],
            maps[i]['price'],
            maps[i]['picture']
        );
        return ingredient;
      });
      return  ingredients[0];
    }
    catch(ex){
      print("error in getIngredient(String name)");
    }

  }

  Future<List<Ingredientamount>> ingredientAmounts() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ingredient_amount');

    List<Ingredient> ingredients = [];
    for( var i = 0 ; i < maps.length; i++ ) {
      Ingredient temp = await getIngredient("name");
      ingredients.add(temp);
    }

    List<Ingredientamount> ingredientAmounts = List.generate(maps.length,(i) {
      //Ingredient ingredient = await getIngredient("name");
      var ingredientAmount =Ingredientamount(
        ingredients[i],
        maps[i]['amount'],
      );
      return ingredientAmount;
    });
    return ingredientAmounts;
  }

  Future<List<im.Step>> steps() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('step');
    var steps = List.generate(maps.length, (i){
      im.Step step = im.Step(
          maps[i]['timer'],
          maps[i]['timer_title'],
          maps[i]['instructions'],
          maps[i]['number']
      );
      return step;
    });
    return steps;
  }



  void insertStep(im.Step step) async{
    var db = await this.database;
    print(step.toJson().toString());
    var result = await db.insert("step", step.toJson());

    print('result: $result');
  }

  void insertIngredient(Ingredient ingredient) async{
    var db = await this.database;
    print(ingredient.toJson().toString());
    /*
    final tables = await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    print(tables);*/
    try{
    var result = await db.insert("ingredient", ingredient.toJson());}
    catch(ex){
      print("insertIngredient error");
    }
    //print('result: $result');
  }
  void insertIngredientAmount(Ingredientamount ingredientamount) async{
    var db = await this.database;
    /*final tables = await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    print(tables);*/
    //print(ingredientamount.toMap().toString());
    var result = await db.insert("ingredient_amount", ingredientamount.toMap());
    print('result: $result');
  }

  void insertRecipe(Recipe recipe) async{
    var db = await this.database;
    try{
      var result = await db.insert("recipe", recipe.toMap());
      print('result: $result');
    }
    catch(e){
      print("insertRecipe error" + "prob unique constraint");
    }
  }


  Future<void> deleteRecipe(String id) async {
    // Get a reference to the database.
    final db = await database;
    // Remove the recipe from the Database.
    await db.delete(
      'recipe',
      // Use a `where` clause to delete a specific recipe.
      where: "id = ?",
      // Pass the recipe's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteAllSteps() async {
    // Get a reference to the database.
    final db = await database;
    // Remove the recipe from the Database.
    await db.delete(
      'step',
      // Use a `where` clause to delete a specific recipe.
      where: "1 or 1",
      // Pass the recipe's id as a whereArg to prevent SQL injection.
    );
  }
  Future<void> deleteAllIngredientAmount() async {
    // Get a reference to the database.
    final db = await database;
    // Remove the recipe from the Database.
    await db.delete(
      'ingredient_amount',
      // Use a `where` clause to delete a specific recipe.
      where: "1 or 1",
      // Pass the recipe's id as a whereArg to prevent SQL injection.
    );
  }

  Future<void> deleteAllIngredients() async {
    // Get a reference to the database.
    final db = await database;
    // Remove the recipe from the Database.
    await db.delete(
      'ingredient',
      // Use a `where` clause to delete a specific recipe.
      where: "1 or 1",
      // Pass the recipe's id as a whereArg to prevent SQL injection.
    );
  }
}
