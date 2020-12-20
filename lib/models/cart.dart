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
  RecipeHelper _recipeHelper= RecipeHelper();

  factory Cart() {
    return _singleton;
  }

  Cart._internal()  {
    //print("Cart._internal");
    //loadCart();
    // TODO Load cart from database
  }
  void loadCart(){
    print("og length: " + this.ingredients.length.toString());
    print("og length recip: " + this.recipes.length.toString());
    _recipeHelper.initializeDatabase().then((value) async{
      //await saveCart();
      this.ingredients = await _recipeHelper.ingredientAmountSelecteds();
      this.recipes = await _recipeHelper.recipeSelecteds();
      //print("CartLoaded");
      print("new length: " + this.ingredients.length.toString());
      print("new length recip: " + this.recipes.length.toString());

      //print(recipes.length);
    });
  }
  void saveCart() async {
    _recipeHelper.insertFullCart(recipes,ingredients);

  }



  bool isEmpty() {
    for (var recipe in recipes) {
      if (recipe.selected) {
        return false;
      }
    }
    return true;
  }

  void setRecipes(List<RecipeInstance> newRecipes) {
    List<RecipeSelected> newNew = [];
    for (var recipe in newRecipes) {
      var found = false;
      for (var r in recipes) {
        if (r.recipe == recipe) {
          found = true;
          newNew.add(r);
        }
      }
      if (!found) {
        newNew.add(RecipeSelected(recipe));
      }
    }
    recipes = newNew;
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

  RecipeSelected(this.recipe) : this.selected = false, this.uuid = Uuid().v4();
  RecipeSelected.fromDB(this.recipe,this.selected,this.uuid);

  void toggleSelect() {
    if (selected) {
      Cart().unselectRecipe(recipe);
    } else {
      Cart().selectRecipe(recipe);
    }
    selected = !selected;
  }

  Map<String, dynamic> toJson(RecipeSelected recipeSelected) => <String, dynamic>{
    'uuid': recipeSelected.uuid,
    'recipeinstance': recipeSelected.recipe.uuid,
    "selected": (recipeSelected.selected)? 1 : 0,
  };

}

class IngredientAmountSelected {
  Ingredient ingredient;
  double amount;
  bool selected = false;

  IngredientAmountSelected(
      {this.ingredient, this.amount, this.selected: false});

  Map<String, dynamic> toJson(IngredientAmountSelected ingredientAmountSelected) => <String, dynamic>{
    'ingredientname': ingredientAmountSelected.ingredient.name,
    'amount': ingredientAmountSelected.amount,
    "selected": (ingredientAmountSelected.selected)? 1 : 0,
  };
}
