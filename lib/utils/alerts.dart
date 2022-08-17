import 'package:flutter/material.dart';

class AlertClass extends StatelessWidget {
  const AlertClass({Key? key, required this.title, required this.message})
      : super(key: key);

  final String title;
  final String message;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK')),
      ],
    );
  }
}
