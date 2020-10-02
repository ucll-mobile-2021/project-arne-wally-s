import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppetiteWidget extends StatelessWidget {
  void _doSomething() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appetite'),
      ),
      body: Center(child: Consumer<MyRecipesService>(
        builder: (context, service, child) {
          return ListView.builder(
            itemCount: service.myRecipes.length,
            itemBuilder: (BuildContext context, int index) {
              Recipe recipe = service.myRecipes[index].recipe;
              return Card(
                child: Column(
                  children: [
                    Image.network(recipe.pictureUrl),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            recipe.name,
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mic),
        onPressed: _doSomething,
      ),
    );
  }
}
