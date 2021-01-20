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
      body: Consumer<MyRecipesService>(builder: (context, service, child) {
        var _recipes = service.myRecipes;
        print(_recipes.length);
        if (_recipes.length > 0) {
          return RecipeInstanceList(_recipes);
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image(
                  image: AssetImage('assets/pan.gif'),
                  height: 250,
                ),
              ),
              Text(
                'Appetite? Add some recipes!',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    //fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ],
          );
        }
      }),
    );
  }
}
