import 'dart:math';

import 'package:abc_cooking/widgets/animating_background.dart';
import 'package:abc_cooking/widgets/camera_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FinishedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatingBackground(
        foreground: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/bon_appetit.png'),
            Column(
              children: [
                Text(
                  "Want to share a picture of your work?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  heroTag: "camerabtn",
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraScreen()));
                  },
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "next",
        child: Icon(Icons.arrow_right),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
