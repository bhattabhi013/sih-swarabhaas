import 'dart:math';

import 'package:flutter/material.dart';
import 'package:swarabhaas/home/model/jitsee_meet.dart';
import 'package:swarabhaas/home/widgets/audio_tile_widget.dart';
import 'package:swarabhaas/utils/alerts.dart';

class AudioCall extends StatefulWidget {
  const AudioCall({Key? key}) : super(key: key);

  @override
  State<AudioCall> createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCall> {
  final _jitsee = JitseeMeet();
  createJitseeMeet() async {
    String meetNumber = (Random().nextInt(1000) + 100).toString();
    _jitsee.joinMeet(room: meetNumber, isAudio: true, isVideo: true);
  }

  joinJitseeMeet() async {
    _jitsee.joinMeet(
        room: _textFieldController.text, isAudio: true, isVideo: true);
  }

  TextEditingController _textFieldController = TextEditingController();

  Future<void> _joinMeetAlert(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter meet number'),
          content: TextField(
            controller: _textFieldController,
            decoration:
                InputDecoration(hintText: "Enter 3 digit unique number"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                joinJitseeMeet();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: mediaquery.size.height * 0.1,
          ),
          const Text("Meet your friends"),
          FlatButton(
            onPressed: () {
              createJitseeMeet();
            },
            child: Text('MEET'),
          ),
          FlatButton(
            onPressed: () {
              // AlertClass(title: 'Enter number', alertNum: 1);
              _joinMeetAlert(context);
            },
            child: Text('Join'),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
