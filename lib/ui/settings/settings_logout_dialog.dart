import 'package:flutter/material.dart';
import 'package:trade_buddy/main.dart' as main;
import 'package:trade_buddy/utils/auth.dart';
import 'package:trade_buddy/ui/login_ui.dart';

class LogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure that you want to logout?"),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Confirm",
          ),
          onPressed: () {
            Auth.signOut().then((b) {
              if (b) {
                main.isLoaded = false;
                main.isSignedIn = false;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login()),
                        (_) => false);
              }
            });
          },
        ),
        FlatButton(
          child: Text(
            "Cancel",
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}