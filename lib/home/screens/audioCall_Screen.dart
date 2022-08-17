import 'dart:math';

import 'package:flutter/material.dart';
import 'package:swarabhaas/home/model/jitsee_meet.dart';
import 'package:swarabhaas/home/widgets/audio_tile_widget.dart';

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
    //_jitsee.joinMeet(room: meetNumber, isAudio: true, isVideo: true);
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              'assets/images/onboarding.jpg',
              height: mediaquery.size.height * 0.3,
              width: mediaquery.size.width * 0.9,
            ),
          ),
          FlatButton(
            onPressed: () {
              createJitseeMeet();
            },
            child: Text('MEET'),
          ),
          // FlatButton(
          //   onPressed: () {
          //     JitseeMeet().joinMeet(room: '', isAudio: true, isVideo: true);
          //   },
          //   child: Text('Join'),
          // ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
