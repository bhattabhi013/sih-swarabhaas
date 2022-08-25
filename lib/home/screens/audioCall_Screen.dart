import 'dart:math';
import 'dart:math' as math;
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:swarabhaas/home/model/jitsee_meet.dart';
import 'package:swarabhaas/home/widgets/audio_tile_widget.dart';
import 'package:swarabhaas/utils/alerts.dart';

class AudioCall extends StatefulWidget {
  AudioCall({Key? key}) : super(key: key);
  final telephony = Telephony.instance;
  @override
  State<AudioCall> createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCall> {
  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];

  @override
  void initState() {
    super.initState();
    _getDialScreen();
  }

  _getDialScreen() async {
    final Iterable<CallLogEntry> result = await CallLog.query();
    setState(() {
      _callLogEntries = result;
    });
  }

  final _jitsee = JitseeMeet();

  createJitseeMeet() async {
    String meetNumber = (Random().nextInt(1000) + 100).toString();
    _jitsee.joinMeet(room: meetNumber, isAudio: true, isVideo: true);
  }

  callDial(CallLogEntry entry) async {
    Telephony.instance.dialPhoneNumber('${entry.number}');
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
                Telephony.instance.sendSms(
                    to: "9891053744", message: "May the force be with you!");
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(appLocalizations.okText),
              onPressed: () {
                //joinJitseeMeet();
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
