import 'dart:math';
import 'package:abc_cooking/widgets/recipe_detail.dart';
import 'package:shimmer/shimmer.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/widgets/recipe_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeList extends StatelessWidget {
  final Future<List<Recipe>> _futureRecipes;
  Function _function;

  RecipeList(this._futureRecipes, bool shouldReturnRecipeInstance) {
    if (shouldReturnRecipeInstance) {
      this._function = returnRecipe;
    } else {
      _function = null;
    }
  }

  RecipeList.function(this._futureRecipes, this._function);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width * 0.5 - 2.5;
    return FutureBuilder(
        future: _futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
              spacing: 5,
              runSpacing: 5,
              children: snapshot.data
                  .map((item) {
                    return Container(
                      width: w,
                      child: RecipeWidget.width(
                          item,
                          _function != null
                              ? () {
                                  Function.apply(_function, [context, item]);
                                }
                              : null,
                          w),
                    );
                  })
                  .toList()
                  .cast<Widget>(),
            );
          }
          if (snapshot.hasError) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image(
                          image: AssetImage('assets/logo_pan.png'),
                          height: 250,
                        ),
                      ),
                      Text(
                        "Could not load recipes from server, because you have no internet connection",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            //fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          var a = [1, 2, 3, 4, 5, 6];
          final random = Random();
          double textWidth = random.nextInt((w * .8).toInt()).toDouble();
          return Wrap(
            spacing: 5,
            runSpacing: 5,
            children: a
                .map((item) {
                  return Container(
                    width: w,
                    child: Card(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Column(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              child: Container(
                                color: Colors.grey,
                                height: w,
                                width: w,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    height: 20,
                                    width: textWidth,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
                .toList()
                .cast<Widget>(),
          );
        });
  }

  void returnRecipe(BuildContext context, Recipe recipe) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeDetailWidget.select(recipe, true)));
    if (result != null) {
      Navigator.pop(context, result);
    }
  }
}
