import 'package:abc_cooking/buy/map_page.dart';
import 'package:abc_cooking/buy/shopping_list.dart';
import 'package:abc_cooking/models/cart.dart';
import 'package:abc_cooking/services/location_service.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MapPage()));
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [BoxShadow(color: Theme.of(context).primaryColor, blurRadius: 5)],
                      image: DecorationImage(
                        image: AssetImage('assets/map.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(35.0),
                            child: Text(
                              'Look for shops nearby',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                  shadows: [
                                    Shadow(
                                      // bottomLeft
                                        offset: Offset(-.7, -.7),
                                        color: Theme.of(context).primaryColor),
                                    Shadow(
                                      // bottomRight
                                        offset: Offset(.7, -.7),
                                        color: Theme.of(context).primaryColor),
                                    Shadow(
                                      // topRight
                                        offset: Offset(.7, .7),
                                        color: Theme.of(context).primaryColor),
                                    Shadow(
                                      // topLeft
                                        offset: Offset(-.7, .7),
                                        color: Theme.of(context).primaryColor),
                                  ]
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              (service.empty())
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 70,),
                        Center(
                          child: Image.asset(
                            "assets/groceries.gif",
                            height: 250.0,
                            width: 250.0,
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
                  : Column(
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
                                DataCell(Text(service
                                    .cart.recipes[index].recipe.recipe.name)),
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
                          Scaffold.of(context).hideCurrentSnackBar();
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
