import 'package:abc_cooking/DB/DB.dart';
import 'package:abc_cooking/models/ingredient.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class Cart {
  static final Cart _singleton = Cart._internal();
  List<RecipeSelected> recipes = [];
  List<IngredientAmountSelected> ingredients = [];
  RecipeHelper _recipeHelper = RecipeHelper();

  factory Cart() {
    return _singleton;
  }

  Cart._internal() {
    //print("Cart._internal");
    loadCart();
    // TODO Load cart from database
  }

  void loadCart() {
    _recipeHelper.initializeDatabase().then((value) async {
      this.ingredients = await _recipeHelper.ingredientAmountSelecteds();
      this.recipes = await _recipeHelper.recipeSelecteds();

      //print(recipes.length);
    });
  }

  void saveCart() async {
    _recipeHelper.insertFullCart(recipes, ingredients);
  }

  bool isEmpty() {
    for (var recipe in recipes) {
      if (recipe.selected) {
        return false;
      }
    }
    return true;
  }

  List<RecipeInstance> getSelected() {
    List<RecipeInstance> newNew = [];
    for (var recipe in recipes) {
      if (recipe.selected) {
        newNew.add(recipe.recipe);
      }
    }
    return newNew;
  }

  void deleteSelected() {
    var rs = getSelected();
    for (var r in rs) {
      removeRecipe(r);
    }
    saveCart();
  }

  void removeRecipe(RecipeInstance recipeInstance) {
    var r = null;
    unselectRecipe(recipeInstance);
    for (var recipe in recipes) {
      if (recipe.recipe == recipeInstance) {
        r = recipe;
      }
    }
    recipes.remove(r);
    saveCart();
  }

  List<RecipeInstance> getRecipeInstances() {
    List<RecipeInstance> instances = [];
    for (var r in recipes) {
      instances.add(r.recipe);
    }
    return instances;
  }

  void addRecipe(RecipeInstance recipe) {
    recipes.add(RecipeSelected(recipe));
    saveCart();
  }

  void selectRecipe(RecipeInstance recipe) {
    for (var ingredient in recipe.recipe.ingredients) {
      var found = false;
      for (var ingr in ingredients) {
        if (ingr.ingredient.name == ingredient.ingredient.name) {
          found = true;
          ingr.amount += ingredient.amount * recipe.persons;
          ingr.selected = false;
        }
      }
      if (!found) {
        ingredients.add(IngredientAmountSelected(
            ingredient: ingredient.ingredient,
            amount: ingredient.amount * recipe.persons));
      }
    }
    saveCart();
  }

  void unselectRecipe(RecipeInstance recipe) {
    List<IngredientAmountSelected> newNew = List.from(ingredients);
    for (var ingredient in recipe.recipe.ingredients) {
      for (var ingr in ingredients) {
        if (ingr.ingredient.name == ingredient.ingredient.name) {
          var amount = ingredient.amount * recipe.persons;
          if ((ingr.amount - amount).abs() < .001) {
            newNew.remove(ingr);
          } else {
            ingr.amount -= amount;
          }
        }
      }
    }
    ingredients = newNew;
    saveCart();
  }
}

class RecipeSelected {
  RecipeInstance recipe;
  bool selected;
  var uuid;

  RecipeSelected(this.recipe)
      : this.selected = false,
        this.uuid = Uuid().v4();

  RecipeSelected.fromDB(this.recipe, this.selected, this.uuid);

  void toggleSelect() {
    selected = !selected;
    if (!selected) {
      Cart().unselectRecipe(recipe);
    } else {
      Cart().selectRecipe(recipe);
    }
    // Cart().saveCart(); This is called in other functions already
  }

  Map<String, dynamic> toJson(RecipeSelected recipeSelected) =>
      <String, dynamic>{
        'uuid': recipeSelected.uuid,
        'recipeinstance': recipeSelected.recipe.uuid,
        "selected": (recipeSelected.selected) ? 1 : 0,
      };

  @override
  String toString() {
    return '${recipe..uuid}';
  }
}

class IngredientAmountSelected {
  Ingredient ingredient;
  double amount;
  bool selected = false;

  IngredientAmountSelected(
      {this.ingredient, this.amount, this.selected: false});

  void toggleSelected() {
    selected = !selected;
    Cart().saveCart();
  }

  @override
  String toString() {
    return "$ingredient: $amount";
  }

  Map<String, dynamic> toJson(
          IngredientAmountSelected ingredientAmountSelected) =>
      <String, dynamic>{
        'ingredientname': ingredientAmountSelected.ingredient.name,
        'amount': ingredientAmountSelected.amount,
        "selected": (ingredientAmountSelected.selected) ? 1 : 0,
      };
}
