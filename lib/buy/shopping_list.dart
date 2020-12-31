import 'package:abc_cooking/models/cart.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ShoppingListState();
  }
}

class ShoppingListState extends State<ShoppingList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyRecipesService>(
      builder: (context, service, child) {
        var cart = service.cart;
        return Scaffold(
          appBar: AppBar(
            title: Text('Shopping list'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                DataTable(
                  columns: [
                    DataColumn(label: Text('Done')),
                    DataColumn(label: Text('Ingredient')),
                    DataColumn(label: Text('Amount')),
                  ],
                  rows: List<DataRow>.generate(cart.ingredients.length, (index) {
                    var ingredient = cart.ingredients[index];
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
                        if (index % 2 == 0) return Colors.grey.withOpacity(0.3);
                        return null; // Use default value for other states and odd rows.
                      }),
                      cells: [
                        DataCell(Checkbox(
                          value: cart.ingredients[index].selected,
                          onChanged: (val) {
                            cart.ingredients[index].toggleSelected();
                            setState(() {});
                          },
                        )),
                        DataCell(
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, right: 8, bottom: 8),
                                child: Image.network(ingredient.ingredient.picture),
                              ),
                              Expanded(child: Text(ingredient.ingredient.name)),
                            ],
                          ),
                        ),
                        DataCell(Text(getAmount(ingredient))),
                      ],
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      /*
                      // This is not needed, since we save the current selected items
                      // And people can always come back later
                      if (cart.ingredients.any((e) => e.selected != true)) {
                        showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Done shopping?'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                          'You haven\'t selected some of you ingredients yet'),
                                      Text(
                                          'Are you sure you wanna close you shopping list?')
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      } else {
                      }
                       */
                      Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.all(15),
                    color: Theme.of(context).accentColor,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    child: Text(
                      'Finish',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  String getAmount(IngredientAmountSelected ingredientamount) {
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
}
