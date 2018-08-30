import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/trade_model.dart';

class CommentaryDialog extends StatelessWidget {
  final Trade trade;
  CommentaryDialog(this.trade) {
    _controller.text = trade.commentary;
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Commentary"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          maxLines: 10,
          controller: _controller,
          validator: (text) {
            if (text.length > 250) {
              return "Please enter between 0 and 250 letters";
            }
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Update Commentary"),
          onPressed: () {
            if (_formKey.currentState.validate()) {
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
}