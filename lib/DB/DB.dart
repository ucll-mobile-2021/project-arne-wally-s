// Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
import 'package:abc_cooking/models/cart.dart';
import 'package:abc_cooking/models/ingredient.dart';
import 'package:abc_cooking/models/ingredient_amount.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/models/timer.dart';
import 'package:abc_cooking/models/step.dart' as im;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class RecipeHelper {
  static Database _database;
  static RecipeHelper _recipeHelper;

  final String recipeTableName = "recipe";

  RecipeHelper._createInstance();

  factory RecipeHelper() {
    if (_recipeHelper == null) {
      _recipeHelper = RecipeHelper._createInstance();
    }
    return _recipeHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "recipe.db";
    var database = await openDatabase(
      path,
      onConfigure: _onConfigure,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
      CREATE TABLE ingredient(name TEXT PRIMARY KEY, measurement_unit TEXT,type TEXT, price REAL, picture TEXT)''');
        db.execute('''
      CREATE TABLE recipe(id TEXT PRIMARY KEY, name TEXT, price INTEGER,veggie INTEGER,vegan INTEGER, healthy INTEGER, prep_time INTEGER, difficulty INTEGER,picture TEXT)''');
        db.execute('''
      CREATE TABLE step(timer INTEGER, number INTEGER, instructions TEXT,timer_title TEXT, id TEXT,FOREIGN KEY(id) REFERENCES recipe(id) ON DELETE CASCADE )''');
        db.execute('''
      CREATE TABLE timer(title TEXT , timeOfCreation TEXT, durationInMinutes INTEGER, durationInSeconds INTEGER)''');
        db.execute('''
      CREATE TABLE ingredient_amount(amount REAL, ingredientName TEXT ,id TEXT ,FOREIGN KEY(ingredientName) REFERENCES ingredient(name) ON DELETE CASCADE, FOREIGN KEY(id) REFERENCES recipe(id) ON DELETE CASCADE)''');
        db.execute('''
      CREATE TABLE recipeinstance(uuid TEXT PRIMARY KEY, recipeid TEXT , persons INTEGER, FOREIGN KEY(recipeid) REFERENCES recipe(id))''');
        db.execute('''
      CREATE TABLE recipeselected(uuid TEXT PRIMARY KEY ,recipeinstance TEXT , selected INTEGER, FOREIGN KEY(recipeinstance) REFERENCES recipeinstance(uuid) ON DELETE CASCADE)''');
        db.execute('''
      CREATE TABLE ingredientamountselected(ingredientname TEXT ,amount REAL ,selected INTEGER)''');
      },
    );

    return database;
  }

  void insertFullCart(List<RecipeSelected> recipes,
      List<IngredientAmountSelected> ingredients) async {
    var db = await this.database;
    await db.delete("recipeselected");
    await db.delete("recipeinstance");
    try {
      recipes.forEach((recipeSelected) async {
        _recipeHelper.insertRecipe(recipeSelected.recipe.recipe);
        _recipeHelper.insertRecipeInstance(recipeSelected.recipe);
        _recipeHelper.insertRecipeSelected(recipeSelected);
      });
    } catch (ex) {
      print("insertFullCart -> error in insertFullCart  recipeSelected");
    }
    try {
      await db.delete("ingredientamountselected");
      ingredients.forEach((ingredientAmountSelected) async {
        //recipe should have added ingredient
        //await _recipeHelper.insertIngredient(ingredientAmountSelected.ingredient);
        await _recipeHelper
            .insertIngredientAmountSelected(ingredientAmountSelected);
      });
    } catch (ex) {
      print(
          "insertFullCart -> error in insertFullCart ingredientAmountSelected");
    }
  }

  Future<List<Recipe>> recipes() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipe');
    return List.generate(maps.length, (i) {
      var recipe1 = Recipe(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['price'],
          (maps[i]['veggie'] == 0) ? false : true,
          (maps[i]['vegan'] == 0) ? false : true,
          maps[i]['healthy'],
          maps[i]['prep_time'],
          maps[i]['difficulty'],
          null,
          null,
          maps[i]['picture']);
      //(recipe1.toString());
      return recipe1;
    });
  }

  Future<List<String>> usedRecipes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipe');
    return List.generate(maps.length, (i) {
      var id = maps[i]['id'];
      return id;
    });
  }


  Future<List<Ingredient>> ingredients() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ingredient');
    var ingredients = List.generate(maps.length, (i) {
      var ingredient = Ingredient(maps[i]['name'], maps[i]['measurement_unit'],
          maps[i]['type'], maps[i]['price'], maps[i]['picture']);
    });
    return ingredients;
  }

  Future<Ingredient> getIngredient(String name) async {
    // Get a reference to the database.
    final Database db = await database;
    if (name != null) {
      try {
        final List<Map<String, dynamic>> maps =
            await db.query('ingredient', where: "name = '$name' ");
        var ingredients = List.generate(maps.length, (i) {
          var ingredient = Ingredient(
              maps[i]['name'],
              maps[i]['measurement_unit'],
              maps[i]['type'],
              maps[i]['price'],
              maps[i]['picture']);
          return ingredient;
        });
        return ingredients[0];
      } catch (ex) {
        print("error in getIngredient(String name)");
        print(ex);
      }
    } else {
      print("getIngredient opgeroepen met naam null???");
    }
  }

  Future<RecipeInstance> getRecipeInstance(String uuid) async {
    // Get a reference to the database.
    final Database db = await database;
    try {
      final List<Map<String, dynamic>> maps =
          await db.query('recipeinstance', where: "uuid = '$uuid' ");
      var recipeInstances = List.generate(maps.length, (i) async {
        var recipe = await getRecipe(maps[i]['recipeid']);
        var persons = maps[i]['persons'];
        var uuid = maps[i]['uuid'];

        return new RecipeInstance.fromDB(recipe, persons, uuid);
      });
      return recipeInstances[0];
    } catch (ex) {
      print("error in getRecipeInstance(String name)");
      print(ex);
    }
  }

  Future<Recipe> getRecipe(String id) async {
    // Get a reference to the database.
    final Database db = await database;
    try {
      final List<Map<String, dynamic>> maps =
          await db.query('recipe', where: "id = '$id' ");

      var recipes = List.generate(maps.length, (i) async {
        var steps = await getStepsForRecipe(maps[i]['id']);
        var ingredientAmounts = await ingredientAmountForRecipe(maps[i]['id']);
        var recipe = Recipe(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['price'],
          (maps[i]['veggie'] == 0) ? false : true,
          (maps[i]['vegan'] == 0) ? false : true,
          maps[i]['healthy'],
          maps[i]['prep_time'],
          maps[i]['difficulty'],
          ingredientAmounts,
          steps,
          maps[i]['picture'],
        );

        return recipe;
      });
      return recipes[0];
    } catch (ex) {
      print("error in getRecipe(String name)");
      //print(ex);
    }
  }

  Future<List<im.Step>> getStepsForRecipe(String id) async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('step');

    List<im.Step> steps = [];
    for (var i = 0; i < maps.length; i++) {
      //maps[i]['name']
      if (maps[i]['id'] != null && maps[i]['id'] == id) {
        im.Step temp = await im.Step(maps[i]['timer'], maps[i]['timer_title'],
            maps[i]['instructions'], maps[i]['number']);
        steps.add(temp);
      }
    }
    return steps;
  }

  Future<Timer> getTimer(String title) async {
    // Get a reference to the database.
    final Database db = await database;
    try {
      final List<Map<String, dynamic>> maps =
          await db.query('timer', where: "title = '$title' ");
      var timers = List.generate(maps.length, (i) {
        Timer timer = timerConstructor(maps[i]['title'],
            maps[i]['durationInMinutes'], maps[i]['timeOfCreation']);
        return timer;
      });

      return timers[0];
    } catch (ex) {
      print("error in getTimer(String name)");
      print(ex);
    }
  }

  Future<List<Ingredientamount>> ingredientAmounts() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ingredient_amount');

    List<Ingredient> ingredients = [];
    for (var i = 0; i < maps.length; i++) {
      Ingredient temp = await getIngredient(maps[i]['ingredientName']);
      ingredients.add(temp);
    }

    List<Ingredientamount> ingredientAmounts = List.generate(maps.length, (i) {
      var ingredientAmount = Ingredientamount(
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
    final List<Map<String, dynamic>> maps =
        await db.query('ingredient_amount', where: "id = '$id'");

    List<Ingredient> ingredients = [];
    for (var i = 0; i < maps.length; i++) {
      Ingredient temp = await getIngredient(maps[i]['ingredientName']);
      ingredients.add(temp);
    }
    List<Ingredientamount> ingredientAmounts = List.generate(maps.length, (i) {
      if (maps[i]['id'] != null && maps[i]['id'] == id) {
        var ingredientAmount = Ingredientamount(
          ingredients[i],
          maps[i]['amount'],
        );
        return ingredientAmount;
      }
      return null;
    });
    return ingredientAmounts;
  }

  Future<List<IngredientAmountSelected>> ingredientAmountSelecteds() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('ingredientamountselected');

    List<Ingredient> ingredients = [];
    for (var i = 0; i < maps.length; i++) {
      //print("ingredientAmountSelecteds + ingredientname = " + maps[i]['ingredientname']);
      var temp = await getIngredient(maps[i]['ingredientname']);
      ingredients.add(temp);
    }
    List<IngredientAmountSelected> ingredientAmountSelecteds =
        List.generate(maps.length, (i) {
      var selected = (maps[i]['selected'] == 0 ? false : true);
      var ingredient = ingredients[i];
      var ingredientAmountSelected = new IngredientAmountSelected(
          ingredient: ingredient,
          amount: maps[i]['amount'],
          selected: selected);
      return ingredientAmountSelected;
    });
    return ingredientAmountSelecteds;
  }

  Future<List<RecipeInstance>> recipeInstances() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipeinstance');

    List<Recipe> recipes = [];
    for (var i = 0; i < maps.length; i++) {
      //print(maps[i]['recipeid']);
      var temp = await getRecipe(maps[i]['recipeid']);
      recipes.add(temp);
    }
    List<RecipeInstance> recipeInstances = List.generate(maps.length, (i) {
      //Ingredient ingredient = await getIngredient("name");
      var recipeInstances = RecipeInstance.fromDB(
          recipes[i], maps[i]['persons'], maps[i]['uuid']);
      return recipeInstances;
    });
    return recipeInstances;
  }

  Future<List<RecipeSelected>> recipeSelecteds() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipeselected');

    List<RecipeInstance> recipeInstances = [];
    for (var i = 0; i < maps.length; i++) {
      var temp = await getRecipeInstance(maps[i]['recipeinstance']);
      recipeInstances.add(temp);
    }
    List<RecipeSelected> recipeSelecteds = List.generate(maps.length, (i) {
      var selected = (maps[i]['selected'] == 0 ? false : true);
      var recipeSelected =
          RecipeSelected.fromDB(recipeInstances[i], selected, maps[i]['uuid']);
      return recipeSelected;
    });
    return recipeSelecteds;
  }

  Future<List<im.Step>> steps() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('step');
    var steps = List.generate(maps.length, (i) {
      im.Step step = im.Step(maps[i]['timer'], maps[i]['timer_title'],
          maps[i]['instructions'], maps[i]['number']);
      return step;
    });
    return steps;
  }

  Future<List<Timer>> timers() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('timer');
    var timers = List.generate(maps.length, (i) {
      Timer timer = timerConstructor(maps[i]['title'],
          maps[i]['durationInMinutes'], maps[i]['timeOfCreation']);
      return timer;
    });
    return timers;
  }

  void insertRecipeSelected(RecipeSelected recipeSelected) async {
    try {
      var db = await this.database;
      var result = await db.query("recipeselected",
          where: "uuid = '${recipeSelected.uuid}'");
      if (result.length > 0) {
        return; // We already added this to the db
      }
      await db.insert("recipeselected", recipeSelected.toJson(recipeSelected));
    } catch (ex) {
      print(ex);
    }
  }

  insertRecipeInstance(RecipeInstance recipeInstancee) async {
    try {
      var db = await this.database;
      var result = await db.query("recipeinstance",
          where: "uuid = '${recipeInstancee.uuid}'");
      if (result.length > 0) {
        return; // We already added this to the db
      }
      await db.insert(
          "recipeinstance", recipeInstancee.toJson(recipeInstancee));
    } catch (ex) {
      print(ex);
    }
  }

  void insertTimer(Timer timer) async {
    try {
      var db = await this.database;
      var result = await db.insert("timer", timer.toJson(timer));
    } catch (ex) {
      print("insertTimer error");
    }
  }

  insertIngredient(Ingredient ingredient) async {
    var db = await this.database;
    //print(ingredient.toJson().toString());
    /*
    final tables = await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    print(tables);*/
    try {
      var result = await db.insert("ingredient", ingredient.toJson());
    } catch (ex) {
      print("insertIngredient error");
      print(ex);
    }
    //print('result: $result');
  }

  void insertIngredientAmount(Ingredientamount ingredientamount) async {
    var db = await this.database;
    var result = await db.insert("ingredient_amount", ingredientamount.toMap());
  }

  void insertIngredientAmountSelected(
      IngredientAmountSelected ingredientAmountSelected) async {
    try {
      var db = await this.database;
      var result = await db.insert("ingredientamountselected",
          ingredientAmountSelected.toJson(ingredientAmountSelected));
    } catch (ex) {
      print("insertIngredientAmountSelected error");
    }
  }

  insertRecipe(Recipe recipe) async {
    var db = await this.database;
    var result = await db.query("recipe", where: "id = '${recipe.id}'");
    if (result.length > 0) {
      return; // We already added this to the db
    }

    try {
      var result = await db.insert("recipe", recipe.toMap());
      try {
        if (recipe.steps != null) {
          recipe.steps.forEach((step) async {
            await insertStep(step, recipe.id);
          });
        }
        if (recipe.ingredients != null) {
          recipe.ingredients.forEach((ingredientAmount) async {
            await insertIngredient(ingredientAmount.ingredient);
            await insertingredientAmount(ingredientAmount, recipe.id);
          });
        }
      } catch (ex) {
        print(ex);
      }
    } catch (e) {
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

  Future<void> deleteAllRecipeSelecteds() async {
    // Get a reference to the database.
    final db = await database;
    // Remove the recipe from the Database.
    await db.delete(
      'recipeselected',
      // Use a `where` clause to delete a specific recipe.
      where: "1 or 1",
      // Pass the recipe's id as a whereArg to prevent SQL injection.
    );
  }

  Future<void> deleteAllRecipeInstances() async {
    // Get a reference to the database.
    final db = await database;
    // Remove the recipe from the Database.
    await db.delete(
      'recipeinstance',
      // Use a `where` clause to delete a specific recipe.
      where: "1 or 1",
      // Pass the recipe's id as a whereArg to prevent SQL injection.
    );
  }

  Future<void> deleteAllingredientamountselecteds() async {
    // Get a reference to the database.
    final db = await database;
    // Remove the recipe from the Database.
    await db.delete(
      'ingredientamountselected',
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

  Timer timerConstructor(
      String title, int durationInMinutes, String timeOfCreation) {
    var temp = Timer(title: title, durationInMinutes: durationInMinutes);
    temp.timeOfCreation = DateTime.parse(timeOfCreation);
    return temp;
  }

  void insertStep(im.Step step, String id) async {
    var db = await this.database;
    //print(step.toJson().toString());
    var result = await db.insert("step", step.StepToJsonForDB(step, id));

    //print('result: $result');
  }

  insertingredientAmount(Ingredientamount ingredientAmount, String id) async {
    var db = await this.database;
    //print(ingredientAmount.toJson().toString());
    var result = await db.insert("ingredient_amount",
        ingredientAmount.ingredientAmountToJsonForDB(ingredientAmount, id));
    //print('result: $result');
  }
}
