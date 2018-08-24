import 'package:flutter/material.dart';
import 'package:trade_buddy/ui/accounts_ui.dart';
import 'package:trade_buddy/ui/legal_ui.dart';
import 'package:trade_buddy/ui/login_ui.dart';
import 'package:trade_buddy/utils/auth.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.format_list_numbered),
          title: Text("Accounts"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Accounts()));
          },
        ),
        Divider(height: 1.0),
        ListTile(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Legal())),
          leading: Icon(Icons.info_outline),
          title: Text("Legal"),
        ),
        Divider(height: 1.0),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Sign Out"),
          onTap: () {
            Auth.signOut().then((b) {
              if (b)
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login()),
                    (_) => false);
            });
          },
        ),
        Divider(height: 1.0),
      ],
    );
  }
}
