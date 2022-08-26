import 'dart:math';
import 'dart:math' as math;
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:swarabhaas/home/model/jitsee_meet.dart';
import 'package:swarabhaas/home/widgets/audio_tile_widget.dart';
import 'package:swarabhaas/utils/alerts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telephony/telephony.dart';

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
      _callLogEntries = result.take(10);
    });
  }

  final _jitsee = JitseeMeet();

  createJitseeMeet() async {
    String meetNumber = (Random().nextInt(1000) + 100).toString();
    // _jitsee.joinMeet(room: meetNumber, isAudio: true, isVideo: true);
    var options = JitsiMeetingOptions(
        roomNameOrUrl: 'https://jitsi.swarabhas.tech/' + meetNumber);
    await JitsiMeetWrapper.joinMeeting(options: options);
  }

  callDial(CallLogEntry entry) async {
    Telephony.instance.dialPhoneNumber('${entry.number}');
  }

  joinJitseeMeet() async {
    //_jitsee.joinMeet(room: meetNumber, isAudio: true, isVideo: true);
    // _jitsee.joinMeet(
    //     room: _textFieldController.text, isAudio: true, isVideo: true);

    var options = JitsiMeetingOptions(
        roomNameOrUrl:
            'https://jitsi.swarabhas.tech/' + _textFieldController.text);
    await JitsiMeetWrapper.joinMeeting(options: options);
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
    final appLocalization = AppLocalizations.of(context);
    const TextStyle mono = TextStyle(fontFamily: 'monospace');
    final List<Widget> children = <Widget>[];
    for (CallLogEntry entry in _callLogEntries) {
      children.add(ListTile(
        leading: Initicon(
            text: ' ${entry.name}',
            elevation: 4,
            backgroundColor:
                Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(1.0)),
        title: Text(' ${entry.name}', style: mono),
        subtitle: Text('${entry.number}', style: mono),
        trailing: InkWell(
          child: Icon(Icons.call),
          onTap: () => {callDial(entry)},
        ),
      ));
    }

    final mediaquery = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // use whichever suits your need
              children: [
                ElevatedButton(
                  child: const Text('Join Meet'),
                  onPressed: () {
                    _joinMeetAlert(context, appLocalization);
                  },
                ),
                ElevatedButton(
                  child: const Text('Create Meet'),
                  onPressed: () {
                    createJitseeMeet();
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: children),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
