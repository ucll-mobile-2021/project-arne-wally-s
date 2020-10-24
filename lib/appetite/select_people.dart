import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/appetite_service.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectPeopleWidget extends StatefulWidget {
  final Recipe recipe;

  SelectPeopleWidget(this.recipe);

  @override
  State<StatefulWidget> createState() {
    return _SelectPeopleState();
  }
}

class _SelectPeopleState extends State<SelectPeopleWidget> {
  int people;

  @override
  void initState() {
    super.initState();
    people = AppetiteService().getPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlineButton(
              child: Icon(Icons.remove),
              onPressed: people > 1
                  ? () {
                      setState(() {
                        people -= 1;
                      });
                    }
                  : null,
            ),
            const SizedBox(
              width: 12,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 2)],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  people.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            OutlineButton(
              child: Icon(Icons.add),
              onPressed: people < 30
                  ? () {
                      setState(() {
                        people += 1;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
      floatingActionButton: RaisedButton(
        onPressed: () {
          // Set default people to latest used value
          AppetiteService().setPeople(people);
          var service = Provider.of<MyRecipesService>(context, listen: false);
          service.addRecipe(RecipeInstance(widget.recipe, people));
          Navigator.pop(context);
        },
        padding: EdgeInsets.all(15),
        color: Theme.of(context).accentColor,
        textColor: Theme.of(context).colorScheme.onSecondary,
        child: Text(
          'ADD TO MY RECIPES',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}