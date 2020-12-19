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
      CREATE TABLE recipe(id TEXT PRIMARY KEY, name TEXT, price INTEGER,veggie INTEGER,vegan INTEGER, healthy INTEGER, prep_time INTEGER, difficulty INTEGER,picture TEXT)''');
      db.execute('''
      CREATE TABLE step(timer INTEGER, number INTEGER, instructions TEXT,timer_title TEXT, id TEXT,FOREIGN KEY(id) REFERENCES recipe(id) ON DELETE CASCADE )''');
      db.execute('''
      CREATE TABLE timer(title TEXT , timeOfCreation TEXT, durationInMinutes INTEGER, durationInSeconds INTEGER)''');
      db.execute('''
      CREATE TABLE ingredient_amount(amount REAL, ingredientName TEXT ,id TEXT ,FOREIGN KEY(ingredientName) REFERENCES ingredient(name), FOREIGN KEY(id) REFERENCES recipe(id) ON DELETE CASCADE)''');
      db.execute('''
      CREATE TABLE recipeinstance(id TEXT , persons INTEGER, FOREIGN KEY(id) REFERENCES recipe(id))''');
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
  Future<Recipe> getRecipe(String id) async {
    // Get a reference to the database.
    final Database db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
          'recipe', where: "id = '$id' ");

      var recipes = List.generate(maps.length, (i) async {
        var steps = await getStepsForRecipe(maps[i]['id']);
        var ingredientAmounts = await ingredientAmountForRecipe(maps[i]['id']);
        var recipe = Recipe(
          maps[i]['id'],
          maps[i]['name'],
            maps[i]['price'],
          (maps[i]['veggie']==0)? false : true,
          (maps[i]['vegan']==0)? false : true,
            maps[i]['healthy'],
            maps[i]['prep_time'],
            maps[i]['difficulty'],
          ingredientAmounts,
            steps,
            maps[i]['picture'],
        );

        return recipe;
      });
      return  recipes[0];
    }
    catch(ex){
      print("error in getIngredient(String name)");
    }

  }

  Future<List<im.Step>> getStepsForRecipe(String id) async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('step');

    List<im.Step> steps = [];
    for( var i = 0 ; i < maps.length; i++ ) {
      //maps[i]['name']
      if(maps[i]['id']!= null && maps[i]['id'] == id){
        im.Step temp = await im.Step(maps[i]['timer'],maps[i]['timer_title'],maps[i]['instructions'],maps[i]['number']);
        steps.add(temp);
      }

    }
    return steps;
  }


  Future<Timer> getTimer(String title) async {
    // Get a reference to the database.
    final Database db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
          'timer', where: "title = '$title' ");
      var timers = List.generate(maps.length, (i) {
        Timer timer = timerConstructor(maps[i]['title'], maps[i]['durationInMinutes'],maps[i]['timeOfCreation']);
        return timer;});


      return  timers[0];
    }
    catch(ex){
      print("error in getTimer(String name)");
      print(ex);
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

  Future<List<Ingredientamount>> ingredientAmountForRecipe(String id) async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ingredient_amount');

    List<Ingredient> ingredients = [];
    for( var i = 0 ; i < maps.length; i++ ) {
      Ingredient temp = await getIngredient("name");
      ingredients.add(temp);
    }
    List<Ingredientamount> ingredientAmounts = List.generate(maps.length,(i) {
      if(maps[i]['id'] != null && maps[i]['id'] == id){
      var ingredientAmount =Ingredientamount(
        ingredients[i],
        maps[i]['amount'],
      );
      return ingredientAmount;}
      return null;
    });
    return ingredientAmounts;
  }

  Future<List<RecipeInstance>> recipeInstances() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipeinstance');

    List<Recipe> recipes = [];
    for( var i = 0 ; i < maps.length; i++ ) {
      //Ingredient temp = await getIngredient("name");
      //recipes.add(temp);
    }

    List<RecipeInstance> recipeInstances = List.generate(maps.length,(i) {
      //Ingredient ingredient = await getIngredient("name");
      var recipeInstances =RecipeInstance(
        recipes[i],
        maps[i]['persons'],
      );
      return recipeInstances;
    });
    return recipeInstances;
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

  Future<List<Timer>> timers() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('timer');
    var timers = List.generate(maps.length, (i){
      Timer timer = timerConstructor(maps[i]['title'], maps[i]['durationInMinutes'],maps[i]['timeOfCreation']);
      return timer;
    });
    return timers;
  }


  void insertRecipeInstance(RecipeInstance recipeInstancee) async{
    var db = await this.database;
    print(recipeInstancee.toJson(recipeInstancee).toString());
    var result = await db.insert("recipeinstance", recipeInstancee.toJson(recipeInstancee) );
    print('result: $result');
  }

  void insertTimer(Timer timer) async{
    var db = await this.database;
    //print(timer.toJson(timer).toString());
    var result = await db.insert("timer", timer.toJson(timer));
    //print('result: $result');
  }

  insertIngredient(Ingredient ingredient) async{
    var db = await this.database;
    print(ingredient.toJson().toString());
    /*
    final tables = await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    print(tables);*/
    try{
    var result = await db.insert("ingredient", ingredient.toJson());}
    catch(ex){
      print("insertIngredient error");
      //print(ex);
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
      try{
      if(recipe.steps!=null){
        recipe.steps.forEach( (step)async { await insertStep(step, recipe.id); });
      }
      if(recipe.ingredients!=null){
        recipe.ingredients.forEach( (ingredientAmount)async {
          await insertIngredient(ingredientAmount.ingredient);
          await insertingredientAmount(ingredientAmount, recipe.id); 
        });
      }
      }catch(ex){
        print("insert recipe error -- wss key constraint error in ingredeint , step of ingredientamount");
      }
      print('result: $result');
    }
    catch(e){
      print("insertRecipe error" + "prob unique constraint");
      print(e);
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

  Future<void> deleteAllRecipes() async {
    // Get a reference to the database.
    final db = await database;
    // Remove the recipe from the Database.
    await db.delete(
      'recipe',
      // Use a `where` clause to delete a specific recipe.
      where: "1 or 1",
      // Pass the recipe's id as a whereArg to prevent SQL injection.
    );
  }

  Future<void> deleteAllTimers() async {
    // Get a reference to the database.
    final db = await database;
    // Remove the recipe from the Database.
    await db.delete(
      'timer',
      // Use a `where` clause to delete a specific recipe.
      where: "1 or 1",
      // Pass the recipe's id as a whereArg to prevent SQL injection.
    );
  }

  Timer timerConstructor(String title, int durationInMinutes,String timeOfCreation ){
    var temp = Timer(title: title,durationInMinutes: durationInMinutes);
    temp.timeOfCreation = DateTime.parse(timeOfCreation);
    return temp;
  }

  void insertStep(im.Step step,String id) async{
    var db = await this.database;
    print(step.toJson().toString());
    var result = await db.insert("step", step.StepToJsonForDB(step,id));

    print('result: $result');
  }

  insertingredientAmount(Ingredientamount ingredientAmount, String id) async {
    var db = await this.database;
    print(ingredientAmount.toJson().toString());
    var result = await db.insert("ingredient_amount", ingredientAmount.ingredientAmountToJsonForDB(ingredientAmount,id));
    print('result: $result');
  }
}
