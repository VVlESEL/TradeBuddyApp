import 'package:flutter/material.dart';
import 'package:trade_buddy/ui/eula_ui.dart';
import 'package:trade_buddy/ui/privacy_policy_ui.dart';

class Legal extends StatefulWidget {
  @override
  _LegalState createState() => _LegalState();
}

class _LegalState extends State<Legal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Legal"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PrivacyPolicy())),
            leading: Icon(Icons.description),
            title: Text("Privacy Policy"),
          ),
          Divider(height: 1.0),
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Eula())),
            leading: Icon(Icons.description),
            title: Text("EULA"),
          ),
          Divider(height: 1.0),
        ],
      ),
    );
  }
}
