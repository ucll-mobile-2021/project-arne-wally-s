import 'dart:math';
import 'package:shimmer/shimmer.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/widgets/recipe_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectRecipeWidget extends StatelessWidget {
  final Future<List<Recipe>> _futureRecipes;

  SelectRecipeWidget(this._futureRecipes);

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
                      child: RecipeWidget.tap(item, () {
                        Navigator.pop(context, item);
                      }),
                    );
                  })
                  .toList()
                  .cast<Widget>(),
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
}
