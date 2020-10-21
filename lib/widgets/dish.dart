import 'package:abc_cooking/models/dish.dart';
import 'package:flutter/material.dart';

class DishWidget extends StatelessWidget {
  Dish dish;
  Function tapAction;

  DishWidget(this.dish);
  DishWidget.tap(this.dish, this.tapAction);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Column(
          children: [
            Image.network(dish.picture),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    dish.name,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        if (tapAction != null) {
          tapAction();
        }
      },
    );
  }
}
