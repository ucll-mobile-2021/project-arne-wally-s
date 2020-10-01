import 'package:flutter/material.dart';

class AppetiteWidget extends StatelessWidget {
  void _doSomething() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appetite'),
      ),
      body: Center(
        child: Text('Appetite'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mic),
        onPressed: _doSomething,
      ),
    );
  }
}
