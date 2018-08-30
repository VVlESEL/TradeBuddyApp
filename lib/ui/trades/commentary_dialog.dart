import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/trade_model.dart';

class CommentaryDialog extends StatefulWidget {
  final Trade trade;
  CommentaryDialog(this.trade);

  @override
  _CommentaryDialogState createState() => _CommentaryDialogState();
}

class _CommentaryDialogState extends State<CommentaryDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();

  @override
  initState(){
    super.initState();
    _controller.text = widget.trade.commentary;
  }

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
              widget.trade.setCommentary(_controller.text);
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