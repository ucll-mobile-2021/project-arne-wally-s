import 'package:abc_cooking/appetite/appetite_page.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:abc_cooking/widgets/recipe_instance_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CookWidget extends StatefulWidget {
  @override
  _CookWidgetState createState() => _CookWidgetState();
}

class _CookWidgetState extends State<CookWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cook'),
      ),
      body: Column(
        children: [
          Consumer<MyRecipesService>(builder: (context, service, child) {
            var _recipes = service.myRecipes;
            if (_recipes.length > 0) {
              return Expanded(
                  child: RecipeInstanceList(_recipes)
              );
            }
            else {
              return Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "You have to add a recipe before you can start cooking!",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              );
            }
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AppetiteWidget()));
        },
      ),
    );
  }
}

