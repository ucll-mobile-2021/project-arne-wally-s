import 'package:abc_cooking/appetite/select_people.dart';
import 'package:abc_cooking/models/ingredient_amount.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeDetailWidget extends StatelessWidget {
  final Recipe _recipe;
  final bool _select;

  RecipeDetailWidget(this._recipe) : this._select = false;

  RecipeDetailWidget.select(this._recipe, this._select);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.width,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(_recipe.name,
                      style: TextStyle(color: Colors.white, shadows: [
                        Shadow(
                            // bottomLeft
                            offset: Offset(-.5, -.5),
                            color: Theme.of(context).primaryColor),
                        Shadow(
                            // bottomRight
                            offset: Offset(.5, -.5),
                            color: Theme.of(context).primaryColor),
                        Shadow(
                            // topRight
                            offset: Offset(.5, .5),
                            color: Theme.of(context).primaryColor),
                        Shadow(
                            // topLeft
                            offset: Offset(-.5, .5),
                            color: Theme.of(context).primaryColor),
                      ])),
                  background: Image.network(
                    _recipe.picture,
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildInfoWidget(
                      context, '${_recipe.price}', Icons.euro, 'Price'),
                  buildInfoWidget(
                      context, '${_recipe.prep_time}', Icons.timelapse, 'Time'),
                  buildInfoWidget(
                      context, '${_recipe.price}', Icons.build, 'Difficulty'),
                  buildInfoWidget(context, '${_recipe.healthy}',
                      Icons.pregnant_woman_rounded, 'Healthy'),
                ],
              ),
              _recipe.ingredients.length > 0
                  ? DataTable(
                      columns: [
                        DataColumn(label: Text('Ingredient')),
                        DataColumn(label: Text('Amount')),
                      ],
                      rows: List<DataRow>.generate(_recipe.ingredients.length,
                          (index) {
                        var ingredient = _recipe.ingredients[index];
                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            // All rows will have the same selected color.
                            if (states.contains(MaterialState.selected))
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.08);
                            // Even rows will have a grey color.
                            if (index % 2 == 0)
                              return Colors.grey.withOpacity(0.3);
                            return null; // Use default value for other states and odd rows.
                          }),
                          cells: [
                            DataCell(Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, right: 8, bottom: 8),
                                  child: FadeInImage.assetNetwork(
                                      image: ingredient.ingredient.picture,
                                      placeholder: 'assets/placeholder.png',
                                    )
                                ),
                                Expanded(child: Text(ingredient.ingredient.name)),
                              ],
                            )),
                            DataCell(Text(getAmount(ingredient))),
                          ],
                        );
                      }),
                    )
                  : SizedBox(),
              SizedBox(
                height: 70,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: _select
          ? FloatingActionButton(
              onPressed: () {
                select(context);
              },
              child: Icon(Icons.add_shopping_cart),
            )
          : null,
    );
  }

  String getAmount(Ingredientamount ingredientamount) {
    switch (ingredientamount.ingredient.measurement_unit) {
      case 'g':
        return '${getNumberAndPrefix(ingredientamount.amount)}g';
      case 'l':
        return '${getNumberAndPrefix(ingredientamount.amount)}l';
      case 'ts':
        return '${ingredientamount.amount} ts';
      default:
        return '${ingredientamount.amount}';
    }
  }

  String getNumberAndPrefix(double number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsPrecision(3)} k';
    }
    if (number >= 1) {
      return '${(number).toStringAsPrecision(3)} ';
    }
    /*
    if (number > 0.1) {
      return '${(number * 10)} d';
    }
    */
    if (number >= 0.01) {
      return '${(number * 100).toStringAsPrecision(3)} c';
    }

    return '${(number * 1000).toStringAsPrecision(3)} m';
  }

  Widget buildInfoWidget(
      BuildContext context, String string, IconData icon, String tooltip) {
    return Column(
      children: [
        Tooltip(
          message: tooltip,
          child: Icon(
            icon,
            color: Theme.of(context).accentColor,
            size: 30,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '$string/10',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  void select(BuildContext context) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SelectPeopleWidget(_recipe)));
    if (result != null) {
      Navigator.pop(context, result);
    }
  }
}
