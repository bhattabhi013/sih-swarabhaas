import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:swarabhaas/home/providers/home_provider.dart';
import 'package:swarabhaas/tabs/screens/tabs_screen.dart';
import 'firebase_options.dart';
import 'login/providers/google_auth_provider.dart';
import 'login/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SwarabhaasApp());
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
      ],
      child: MaterialApp(
        title: 'Swarabhaas',
        home: LoginPage(),
        routes: {'/routes': (ctx) => TabsScreen()},
      ),
    );
  }
}
