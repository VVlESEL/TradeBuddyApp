import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/settings_controller.dart';
import 'package:trade_buddy/utils/trade_model.dart';

showCommentaryDialog(BuildContext context, Trade trade) {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();
  _controller.text = trade.commentary;

  return AlertDialog(
    title: Text("Commentary"),
    content: Form(
      key: _formKey,
      child: TextFormField(
        maxLines: 10,
        controller: _controller,
        validator: (text){
          if(text.length > 250){
            return "Please enter between 0 and 250 letters";
          }
        },
      ),
    ),
    actions: <Widget>[
      FlatButton(
        child: Text("Update Commentary"),
        onPressed: () {
          if(_formKey.currentState.validate()) {
            trade.setCommentary(_controller.text);
            Navigator.pop(context);
          }
        },
      ),
      FlatButton(
        child: Text("Cancel"),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}

showStrategiesDialog(BuildContext context, Trade trade) {
  return AlertDialog(
    title: Text("Strategies"),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: SettingsController.strategies?.keys?.map((strategy) {
              return Card(
                elevation: 1.0,
                color: SettingsController.strategies[strategy] == trade.strategy
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                child: ListTile(
                  title: Text("$strategy"),
                  onTap: () {
                    trade.setStrategy(SettingsController.strategies[strategy]);
                    Navigator.pop(context);
                  },
                ),
              );
            })?.toList() ??
            [Text("No Strategies found...")],
      ),
    ),
    actions: <Widget>[
      FlatButton(
        child: Text("Remove Strategy"),
        onPressed: () {
          trade.setStrategy(null);
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text("Cancel"),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}
