import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:swarabhaas/home/providers/getDialCalls.dart';
import 'package:swarabhaas/home/providers/home_provider.dart';
import 'package:swarabhaas/tabs/screens/tabs_screen.dart';
import 'firebase_options.dart';
import 'login/providers/google_auth_provider.dart';
import 'login/screens/login.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SwarabhaasApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((dynamic task, dynamic inputData) async {
    print('Background Services are Working!');
    try {
      final Iterable<CallLogEntry> cLog = await CallLog.get();
      print('Queried call log entries');
      for (CallLogEntry entry in cLog) {
        print('-------------------------------------');
        print('F. NUMBER  : ${entry.formattedNumber}');
        print('C.M. NUMBER: ${entry.cachedMatchedNumber}');
        print('NUMBER     : ${entry.number}');
        print('NAME       : ${entry.name}');
        print('TYPE       : ${entry.callType}');
        //print('DATE       : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp)}');
        print('DURATION   : ${entry.duration}');
        print('ACCOUNT ID : ${entry.phoneAccountId}');
        print('ACCOUNT ID : ${entry.phoneAccountId}');
        print('SIM NAME   : ${entry.simDisplayName}');
        print('-------------------------------------');
      }
      return true;
    } on PlatformException catch (e, s) {
      // print(e);
      // print(s);
      return true;
    }
  });
}

class SwarabhaasApp extends StatelessWidget {
  SwarabhaasApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swarabhaas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Open-Sauce-Sans',
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  LandingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (context) => HomePageProvider()),
        ChangeNotifierProvider(create: (context) => CallHistoryProvider()),
      ],
      child: MaterialApp(
        title: 'Swarabhaas',
        home: LoginPage(),
        routes: {'/routes': (ctx) => TabsScreen()},
      ),
    );
  }
}
