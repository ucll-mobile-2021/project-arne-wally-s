import 'package:abc_cooking/services/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyWidget extends StatelessWidget {
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
              var items = service.myRecipes;
              return Expanded(
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Text('${items[index].recipe.name}');
                    }),
              );
            },
          )
        ],
      ),
    );
  }
}
