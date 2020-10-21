import 'package:abc_cooking/models/dish.dart';
import 'package:abc_cooking/widgets/dish.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DishSelectWidget extends StatelessWidget {
  final Future<List<Dish>> futureDishes;

  DishSelectWidget(this.futureDishes);

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pop(context, item);
                  }),
                );
              }).toList().cast<Widget>(),
            );
            return GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    childAspectRatio: .8),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: DishWidget.tap(snapshot.data[index], () {
                      Navigator.pop(context, snapshot.data[index]);
                    }),
                  );
                });
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
