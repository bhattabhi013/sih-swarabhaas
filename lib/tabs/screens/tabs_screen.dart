import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:swarabhaas/home/screens/audioCall_Screen.dart';
import 'package:swarabhaas/home/screens/home.dart';
import 'package:swarabhaas/home/screens/video_screen.dart';
import 'package:swarabhaas/login/providers/google_auth_provider.dart';
import 'package:swarabhaas/tabs/provider/localProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swarabhaas/utils/webViewCont.dart';
import 'package:url_launcher/url_launcher.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen();
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late List<Widget> _pages;
  int _SelectedPageIndex = 0;
  _selectPage(int index) {
    setState(() {
      _SelectedPageIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [
      HomePage(),
      VideoScreen(),
      AudioCall(),
    ];
    super.initState();
  }

  _launchURL() async {
    var url = Uri.parse("https://swarabhaas.netlify.app/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewContainer(url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final googleAuth = Provider.of<GoogleSignInProvider>(context);
    final mediaquery = MediaQuery.of(context);
    var selectedLocale = Localizations.localeOf(context).toString();
    final appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white12,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              appLocalizations.hi,
              softWrap: true,
              style: const TextStyle(
                fontFamily: 'Open-Sauce-Sans',
                color: Colors.black,
              ),
            ),
            Flexible(
              child: Text(
                ' ${user?.displayName.toString()}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Open-Sauce-Sans',
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              final provider =
                  Provider.of<LocaleProvider>(context, listen: false);
              provider.set();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.0),
              child: SvgPicture.asset(
                'assets/images/lang.svg',
                fit: BoxFit.cover,
                width: mediaquery.size.width * 0.1,
                height: mediaquery.size.height * 0.1,
              ),
            ),
          ),
          InkWell(
            onTap: () => _handleURLButtonPress(
                context, "https://swarabhaas.netlify.app/"),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.0),
              child: Image.asset(
                'assets/images/isl-icon.png',
                width: mediaquery.size.width * 0.08,
                height: mediaquery.size.height * 0.04,
              ),
            ),
          ),
          InkWell(
            onTap: () => signOut(googleAuth),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.0),
              child: Image.asset(
                'assets/images/appbar_icon.png',
                fit: BoxFit.cover,
                width: mediaquery.size.width * 0.15,
                height: mediaquery.size.height * 0.2,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: _pages[_SelectedPageIndex],
        color: Colors.white,
      ),
      bottomNavigationBar: Container(
        // padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 10.0),
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 25.0),
        decoration: BoxDecoration(
          color: Colors.white12,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 184, 184, 184).withOpacity(0.3),
              spreadRadius: 15,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          child: BottomNavigationBar(
            onTap: _selectPage,
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.blueGrey,
            selectedItemColor: Colors.red,
            currentIndex: _SelectedPageIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: const Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: Icon(
                      Icons.home_outlined,
                    ),
                  ),
                  label: appLocalizations.home),
              BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: Icon(
                    Icons.videocam_outlined,
                  ),
                ),
                label: appLocalizations.video,
              ),
              BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: Icon(
                    Icons.phone_in_talk_outlined,
                  ),
                ),
                label: appLocalizations.audio,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeLang() {}

  void signOut(GoogleSignInProvider gAuth) {
    if (user!.providerData[0].providerId == "google.com") {
      // signed via google
      gAuth.handleSignOut();
    }
  }
}
