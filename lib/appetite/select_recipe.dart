import 'package:abc_cooking/models/dish.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/add_dish_service.dart';
import 'package:abc_cooking/widgets/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectRecipeWidget extends StatefulWidget {
  final Dish dish;
  final int people;
  final AddDishService service = AddDishService();

  SelectRecipeWidget(this.dish, this.people);

  @override
  _SelectRecipeState createState() {
    return _SelectRecipeState();
  }
}

class _SelectRecipeState extends State<SelectRecipeWidget> {
  Future<List<Recipe>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = widget.service.getRecipesForDish(widget.dish);
  }

  @override
  Widget build(BuildContext context) {
    // TODO
    return Scaffold(
      appBar: AppBar(
        title: Text('Select recipe'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,itemBuilder: (context, index) {
                  return RecipeWidget(snapshot.data[index]);
            });
          }
          else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return Center(child:CircularProgressIndicator());
        },
      )
    );
  }
}