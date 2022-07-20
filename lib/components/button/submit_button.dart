import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  const SubmitButton({
    @required this.label,
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            padding: EdgeInsets.all(20),
            child: Text(label.toUpperCase()),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
