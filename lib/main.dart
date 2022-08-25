import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:swarabhaas/home/providers/getDialCalls.dart';
import 'package:swarabhaas/home/providers/home_provider.dart';
import 'package:swarabhaas/l10N/i10N.dart';
import 'package:swarabhaas/tabs/provider/localProvider.dart';
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
  Locale? defaultLanguage;

  LandingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //final appLocalization = AppLocalizations.of(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (context) => HomePageProvider()),
        ChangeNotifierProvider(create: (context) => CallHistoryProvider()),
      ],
      child: ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
        child: Consumer<LocaleProvider>(
            builder: (context, provider, child) => MaterialApp(
                  locale: Provider.of<LocaleProvider>(context).locale,
                  title: 'Swarabhaas',
                  home: const LoginPage(),
                  supportedLocales: L10n.all,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  routes: {'/routes': (ctx) => TabsScreen()},
                  localeResolutionCallback: (locale, supportedLocales) {
                    if (defaultLanguage != null) {
                      Intl.defaultLocale = defaultLanguage!.toLanguageTag();
                      return defaultLanguage;
                    }
                    if (locale == null) {
                      Intl.defaultLocale =
                          supportedLocales.first.toLanguageTag();
                      return supportedLocales.first;
                    }
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode == locale.languageCode) {
                        Intl.defaultLocale = supportedLocale.toLanguageTag();
                        return supportedLocale;
                      }
                    }
                    Intl.defaultLocale = supportedLocales.first.toLanguageTag();
                    return supportedLocales.first;
                  },
                )),
      ),
    );
  }
}
