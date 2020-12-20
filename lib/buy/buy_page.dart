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
    if (cart.ingredients.length == 0) {
      print("ingredients are 0 so load cart");
      //cart.loadCart();
      print("ingredients found " + cart.ingredients.length.toString());
    }

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
          RaisedButton(
              child: Text("save"),
              onPressed: () {
                var cart = Cart();
                cart.saveCart();

              }),
          RaisedButton(
              child: Text("load"),
              onPressed: () {
                var cart = Cart();
                print("@@@@@@@@@@@@@@");
                print("pre-load ingr: " + cart.ingredients.length.toString());
                print("pre-load recipi: " + cart.recipes.length.toString());
                cart.loadCart();
                print("##############");
                print("post-load ingri: " + cart.ingredients.length.toString());
                print("post-load recipi: " + cart.recipes.length.toString());
                setState(() {});

              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: !Cart().isEmpty()
            ? () {
                shop(context);
              }
            : () {
          final snackBar = SnackBar(
            content: Text('Your shopping cart is empty'),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        },
      ),
    );
  }

  void shop(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ShoppingList()));
  }
}
