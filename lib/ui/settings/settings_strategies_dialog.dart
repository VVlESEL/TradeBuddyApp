import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/settings_controller.dart';

class StrategiesDialog extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerStrategie = TextEditingController();
  final TextEditingController _controllerAbbreviation = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Strategies"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder(
              initialData: SettingsController.strategies,
              stream: SettingsController.strategiesStream,
              builder: (BuildContext context, AsyncSnapshot<Map> snapshot) =>
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: SettingsController.strategies.length == 0
                          ? [
                              Text("Register your first strategy for this "
                                  "account below. Provide the full name of "
                                  "the strategie in the left text field "
                                  "and a short form in the right text field.")
                            ]
                          : snapshot.data?.keys?.map((strategy) {
                              return Dismissible(
                                key: Key(strategy),
                                onDismissed: (direction) => SettingsController
                                    .removeStrategiy(strategy),
                                child: Card(
                                  elevation: 1.0,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "$strategy,${snapshot.data[strategy]}",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })?.toList()),
            ),
            Form(
              key: _formKey,
              child: Row(children: <Widget>[
                Flexible(
                    flex: 5,
                    child: TextFormField(
                      maxLines: 1,
                      controller: _controllerStrategie,
                      validator: (text) {
                        if (text.length < 3 || text.length > 15) {
                          return "Strategy (3-15 letters)";
                        }
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                ),
                Flexible(
                    flex: 2,
                    child: TextFormField(
                      maxLines: 1,
                      controller: _controllerAbbreviation,
                      validator: (text) {
                        if (text.length < 3 || text.length > 5) {
                          return "3-5 letters";
                        }
                      },
                    )),
                Flexible(
                  flex: 1,
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(horizontal: 0.1),
                    child: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        SettingsController.addStrategiy({
                          _controllerStrategie.text:
                              _controllerAbbreviation.text
                        });
                        _controllerStrategie.clear();
                        _controllerAbbreviation.clear();
                      }
                    },
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Done"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
