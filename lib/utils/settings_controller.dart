import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'dart:async';

class SettingsController {
  //get a reference to the trades db entry of the user
  static final DatabaseReference reference = FirebaseDatabase.instance
      .reference()
      .child("user/${Auth.user.uid}/settings");

  static double balance = 0.0;

  ///The function initializes the controller
  static Future<void> initialize() async {
    //add a listener for new child and check if it meets the filter criteria
    reference.onChildChanged.listen((event) {
      balance = event.snapshot.value["balance"];
    });
  }
}