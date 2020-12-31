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
    return Consumer<MyRecipesService>(builder: (context, service, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Buy'),
        ),
        body: (service.empty())
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.shopping_cart,
                      size: 250,
                      color: Theme.of(context).primaryColor.withAlpha(240),
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
              )
            : SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DataTable(
                      columns: [
                        DataColumn(label: Text('Selected')),
                        DataColumn(label: Text('Recipe')),
                        DataColumn(label: Icon(Icons.people)),
                      ],
                      rows: List<DataRow>.generate(
                        service.cart.recipes.length,
                        (index) {
                          return DataRow(cells: [
                            DataCell(Checkbox(
                              onChanged: (val) {
                                service.cart.recipes[index].toggleSelect();
                                setState(() {});
                              },
                              value: service.cart.recipes[index].selected,
                            )),
                            DataCell(Text(
                                service.cart.recipes[index].recipe.recipe.name)),
                            DataCell(Center(
                                child: Text(service
                                    .cart.recipes[index].recipe.persons
                                    .toString()))),
                          ]);
                        },
                      ),
                    ),
                  ],
                ),
            ),
        floatingActionButton: Cart().isEmpty()
            ? SizedBox()
            : Stack(
                children: [
                  Positioned(
                    bottom: 63,
                    right: 0,
                    child: FloatingActionButton(
                        heroTag: "btn1",
                        child: Icon(Icons.remove),
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          service.deleteSelected();
                          setState(() {});
                        }),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FloatingActionButton(
                        heroTag: "btn2",
                        child: Icon(Icons.shopping_cart),
                        onPressed: () {
                          shop(context);
                        }),
                  ),
                ],
              ),
      );
    });
  }

  void shop(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ShoppingList()));
  }
}
