import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/widgets/recipe_instance_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class RecipeInstanceList extends StatelessWidget {
  final List<RecipeInstance> _recipeInstances;

  RecipeInstanceList(this._recipeInstances);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width * 0.5 - 2.5;
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, i) {
          return SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 136,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: WaterfallFlow.builder(
                  itemCount: _recipeInstances.length,
                  itemBuilder: (BuildContext context, int index) =>
                      RecipeInstanceWidget.width(_recipeInstances[index], w),
                  //cacheExtent: 0.0,
                  padding: EdgeInsets.all(4.0),
                  gridDelegate:
                      SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                ),
                // Same result, less performance down here
                /*StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: _recipeInstances.length,
                  itemBuilder: (BuildContext context, int index) =>
                      RecipeInstanceWidget.width(_recipeInstances[index], w),
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),*/
              ),
            ),
          );
        });
  }
}
