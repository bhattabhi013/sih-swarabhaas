import 'dart:math';

import 'package:flutter/material.dart';
import 'package:swarabhaas/home/model/jitsee_meet.dart';
import 'package:swarabhaas/home/widgets/audio_tile_widget.dart';
import 'package:swarabhaas/utils/alerts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  Future<void> _joinMeetAlert(
      BuildContext context, AppLocalizations appLocalizations) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(appLocalizations.enterMeetNumber),
          content: TextField(
            controller: _textFieldController,
            decoration:
                InputDecoration(hintText: appLocalizations.enterThreeNums),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(appLocalizations.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(appLocalizations.okText),
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
    final appLocalization = AppLocalizations.of(context);
    final mediaquery = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [Text('hello')],
          ),
          SizedBox(
            height: mediaquery.size.height * 0.1,
          ),
          Text(appLocalization.meetYourFriends),
          FlatButton(
            onPressed: () {
              createJitseeMeet();
            },
            child: Text(appLocalization.meet),
          ),
          FlatButton(
            onPressed: () {
              //AlertClass(title: 'Enter number', alertNum: 1);
              _joinMeetAlert(context, appLocalization);
            },
            child: Text(appLocalization.join),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
