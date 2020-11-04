import 'package:abc_cooking/models/recipe.dart';
import 'package:flutter/material.dart';

class CookDetailWidget extends StatefulWidget {
  final RecipeInstance _recipeInstance;

  CookDetailWidget(this._recipeInstance);

  @override
  _CookDetailWidgetState createState() => _CookDetailWidgetState();
}

class _CookDetailWidgetState extends State<CookDetailWidget> {
  int _counter = 0;

  void _increment() {
    if(_counter < widget._recipeInstance.recipe.steps.length - 1)
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    if(_counter > 0) {
      setState(() {
        _counter--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.width,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(widget._recipeInstance.recipe.name,
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
                  widget._recipeInstance.recipe.picture,
                  fit: BoxFit.cover,
                )
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Expanded(
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Step ${widget._recipeInstance.recipe.steps[_counter].number}',
                      style: Theme.of(context).textTheme.headline5,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      '${widget._recipeInstance.recipe.steps[_counter].instructions}',
                      style: Theme.of(context).textTheme.headline6,),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
                      onPressed: _decrement,
                      padding: EdgeInsets.all(15),
                      textColor: Theme.of(context).primaryColor,
                      child: Text('Previous'),
                    ),
                    RaisedButton(
                      onPressed: _increment,
                      padding: EdgeInsets.all(15),
                      color: Theme.of(context).accentColor,
                      textColor: Theme.of(context).colorScheme.onSecondary,
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    ));
  }
}

