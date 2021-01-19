import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final bool isActive;

  Dot(this.isActive);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Theme.of(context).accentColor.withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: isActive ? Theme.of(context).accentColor : Color(0XFFEAEAEA),
        ),
      ),
    );
  }
}

class HorizontalDots extends StatelessWidget {
  final int length, selected;

  HorizontalDots(this.length, this.selected);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(i == selected ? Dot(true) : Dot(false));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}
