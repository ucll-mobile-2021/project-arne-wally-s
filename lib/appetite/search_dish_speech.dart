import 'package:abc_cooking/models/dish.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchDishSpeechWidget extends StatefulWidget {
  @override
  _SearchDishSpeechWidget createState() {
    return _SearchDishSpeechWidget();
  }
}

class _SearchDishSpeechWidget extends State<SearchDishSpeechWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search dish'),
      ),
      body: Center(
        child: Text('Coming soon'),
      ),
    );
  }
}

class ReturnTypeSpeechSearch {
  final Dish dish;
  final int people;

  ReturnTypeSpeechSearch(this.dish, this.people);
}
