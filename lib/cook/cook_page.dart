import 'package:abc_cooking/appetite/appetite_page.dart';
import 'package:abc_cooking/cook/cook_detail.dart';
import 'package:abc_cooking/models/recipe.dart';
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
                  child: RecipeInstanceList.function(_recipes, cookDetail)
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

void cookDetail(BuildContext context, RecipeInstance recipeInstance) {
  if (recipeInstance.recipe.steps.length > 0) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CookDetailWidget(recipeInstance)));
  }
  else {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Woops!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('It seems like this recipe has no instructions.'),
                Text('This problem has been reported to our support team'),
                Text('Sorry for the inconvenience!')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                // TODO Make sure the bad recipe gets removed
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

}

