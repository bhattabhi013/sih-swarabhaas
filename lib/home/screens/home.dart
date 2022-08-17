import 'package:firebase_auth/firebase_auth.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:swarabhaas/home/providers/home_provider.dart';
import 'package:swarabhaas/login/providers/google_auth_provider.dart';
import 'package:swarabhaas/utils/alerts.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool startedConverting = false;
  String _lastWords = '';
  stt.SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _text = 'Start live captioning by clicking the button below';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final googleAuth = Provider.of<GoogleSignInProvider>(context);
    final mediaquery = MediaQuery.of(context);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FloatingActionButton(
            elevation: 2,
            onPressed: _listen,
            backgroundColor: Colors.white,
            focusColor: Colors.blue,
            splashColor: Colors.grey,
            child: !_isListening
                ? Icon(Icons.mic, color: Colors.blue)
                : Icon(Icons.mic_off, color: Colors.red),
          ),
        ),
        body: !startedConverting
            ? Column(
                children: [
                  SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                      child: Text(
                        _text,
                        style: TextStyle(
                          fontSize: mediaquery.size.height * 0.03,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1.0),
                    child: SvgPicture.asset(
                      'assets/images/homepage_icon.svg',
                      fit: BoxFit.fill,
                      width: mediaquery.size.width * 0.5,
                      height: mediaquery.size.height * 0.3,
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    ' Accuracy : ' + _confidence.toStringAsFixed(2),
                    style: TextStyle(color: Colors.blueGrey, fontSize: 25),
                  )),
                  SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                      child: Text(
                        _text,
                      ),
                    ),
                  ),
                ],
              ));
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            startedConverting = true;
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence * 100;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   final googleAuth = Provider.of<GoogleSignInProvider>(context);
  //   final mediaquery = MediaQuery.of(context);
  //   // final home_provider = Provider.of<HomePageProvider>(context);
  //   // print('user $user');
  //   return Scaffold(
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         FlatButton(
  //           onPressed: () {
  //             signOut(googleAuth);
  //           },
  //           textColor: Colors.purple,
  //           child: const Text('Sign out'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // void _startListening() async {
  //   await _speechToText.listen(onResult: _onSpeechResult);
  //   setState(() {});
  // }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Speech Demo'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.all(16),
  //             child: Text(
  //               'Recognized words:',
  //               style: TextStyle(fontSize: 20.0),
  //             ),
  //           ),
  //           Expanded(
  //             child: Container(
  //               padding: EdgeInsets.all(16),
  //               child: Text(
  //                 // If listening is active show the recognized words
  //                 _speechToText.isListening
  //                     ? '$_lastWords'
  //                     // If listening isn't active but could be tell the user
  //                     // how to start it, otherwise indicate that speech
  //                     // recognition is not yet ready or not supported on
  //                     // the target device
  //                     : _speechEnabled
  //                         ? 'Tap the microphone to start listening...'
  //                         : 'Speech not available',
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed:
  //           // If not yet listening for speech start, otherwise stop
  //           _speechToText.isNotListening ? _startListening : _stopListening,
  //       tooltip: 'Listen',
  //       child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
  //     ),
  //   );
  // }
}
