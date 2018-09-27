import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/settings_controller.dart';

class SymbolsDialog extends StatefulWidget {
  @override
  _SymbolsDialogState createState() => _SymbolsDialogState();
}

class _SymbolsDialogState extends State<SymbolsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerSymbol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Symbols"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder(
              initialData: SettingsController.symbols,
              stream: SettingsController.symbolsStream,
              builder: (BuildContext context, AsyncSnapshot<Map> snapshot) =>
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: SettingsController.symbols.length <= 1
                          ? [
                              Text(
                                  "Register your first symbol for this account "
                                  "below. Provide the name in the text field "
                                  "exactly as it is written in the MT4.")
                            ]
                          : snapshot.data?.keys?.map((symbol) {
                              return symbol == "*"
                                  ? Container(
                                      width: 0.0,
                                      height: 0.0,
                                    )
                                  : Dismissible(
                                      key: Key(symbol),
                                      onDismissed: (direction) =>
                                          SettingsController.removeSymbol(
                                              symbol),
                                      child: Card(
                                        elevation: 1.0,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "$symbol",
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
                    flex: 7,
                    child: TextFormField(
                      maxLines: 1,
                      controller: _controllerSymbol,
                      validator: (text) {
                        if (text.length < 3 || text.length > 15) {
                          return "Symbol (3-15 letters)";
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
                        SettingsController.addSymbol(
                            _controllerSymbol.text, true);
                        _controllerSymbol.clear();
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
