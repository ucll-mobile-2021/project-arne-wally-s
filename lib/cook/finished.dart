
import 'package:abc_cooking/widgets/camera_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FinishedPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CameraScreen()));
        },
      ),
    );
  }

}