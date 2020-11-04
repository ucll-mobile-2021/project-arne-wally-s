import 'package:abc_cooking/buy/shopping_list.dart';
import 'package:abc_cooking/models/cart.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BuyWidgetState();
  }
}

class BuyWidgetState extends State<BuyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy'),
      ),
      body: Column(
        children: [
          Consumer<MyRecipesService>(
            builder: (context, service, child) {
              var cart = Cart();
              cart.setRecipes(service.myRecipes);
              if (cart.recipes.length == 0) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text('You should add recipes first')),
                );
              }
              return DataTable(
                  columns: [
                    DataColumn(label: Text('Selected')),
                    DataColumn(label: Text('Recipe')),
                    DataColumn(label: Icon(Icons.people)),
                  ],
                  rows: List<DataRow>.generate(cart.recipes.length, (index) {
                    return DataRow(cells: [
                      DataCell(Checkbox(
                        onChanged: (val) {
                          cart.recipes[index].toggleSelect();
                          setState(() {});
                        },
                        value: cart.recipes[index].selected,
                      )),
                      DataCell(Text(cart.recipes[index].recipe.recipe.name)),
                      DataCell(Center(
                          child: Text(
                              cart.recipes[index].recipe.persons.toString()))),
                    ]);
                  }));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: Cart().recipes.length > 0
            ? () {
                shop(context);
              }
            : null,
      ),
    );
  }

  void shop(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ShoppingList()));
  }
}
