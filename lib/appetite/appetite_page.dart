import 'package:abc_cooking/appetite/search_dish.dart';
import 'package:abc_cooking/appetite/search_dish_speech.dart';
import 'package:abc_cooking/appetite/select_recipe.dart';
import 'package:abc_cooking/models/dish.dart';
import 'package:abc_cooking/services/add_dish_service.dart';
import 'package:abc_cooking/widgets/dish.dart';
import 'package:flutter/material.dart';

class AppetiteWidget extends StatelessWidget {
  final AddDishService service = AddDishService();
  final Future<List<Dish>> futureDishes;

  AppetiteWidget() : futureDishes = AddDishService().getSearchDishResults('');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appetite'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _searchManually(context);
              })
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Recommended for you',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          buildRecommended(context),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mic),
        onPressed: () {
          _listenSpeech(context);
        },
      ),
    );
  }

  Widget buildRecommended(BuildContext context) {
    return FutureBuilder(
        future: futureDishes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
              spacing: 5,
              runSpacing: 5,
              children: snapshot.data.map((item) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.5 - 2.5,
                  child: DishWidget.tap(item, () {
                    _selectRecipe(context, item, service.getPeople());
                  }),
                );
              }).toList().cast<Widget>(),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  void _selectRecipe(BuildContext context, Dish dish, int people) async {
    var recipeInstance = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectRecipeWidget(dish, people)));
    if (recipeInstance != null) {
      // TODO
    }
  }

  void _selectDish(BuildContext context, Dish dish, int people) async {
    if (dish != null) {
      _selectRecipe(context, dish, people);
    }
  }

  void _listenSpeech(BuildContext context) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchDishSpeechWidget()));
    if (result != null) {
      var r = result as ReturnTypeSpeechSearch;
      _selectDish(
          context, r.dish, r.people > 0 ? r.people : service.getPeople());
    }
  }

  void _searchManually(BuildContext context) async {
    _selectDish(
        context,
        await showSearch(context: context, delegate: SearchDish(service)),
        service.getPeople());
  }
}
