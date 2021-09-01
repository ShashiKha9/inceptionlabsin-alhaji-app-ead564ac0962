import 'package:alhaji_user_app/provider/auth.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utils/commons.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthProvider authProvider = AuthProvider();
  SessionProvider sessionProvider = SessionProvider();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), navigate);
  }

  Future<void> navigate() async {
    if (authProvider.auth.currentUser != null) {
      await sessionProvider.initializeSession(authProvider.auth.currentUser.phoneNumber.substring(3));

      await Navigator.pushReplacementNamed(context, '/branches');

      print(authProvider.auth.currentUser.phoneNumber.substring(3));
    } else
      Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    sessionProvider = Provider.of<SessionProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);
    String image() {
      double width = MediaQuery.of(context).size.width;
      if (width < 600) {
        return 'assets/images/beef.png';
      } else if (width > 600 && width < 1200) {
        return 'assets/images/beef2.png';
      } else {
        return 'assets/images/beef2.png';
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(image()), fit: BoxFit.cover)),
          ),
          Positioned(
            top: 40,
            left: 30,
            child: Container(
              width: 300,
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Welcome to',
                      style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Alhaji Suya',
                      style: TextStyle(color: Commons.bgColor, fontSize: 48, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Your favorite foods delivered fast at your door.',
                      style: TextStyle(color: Commons.greyAccent2, fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
