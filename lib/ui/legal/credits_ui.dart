import 'package:flutter/material.dart';

class Credits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Credits"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Text("Login screen photo by Yiran Ding on Unsplash"),
            Padding(padding: const EdgeInsets.symmetric(vertical: 4.0)),
          ],
        ),
      ),
    );
  }
}
