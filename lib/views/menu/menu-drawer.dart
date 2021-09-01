import 'package:alhaji_user_app/provider/auth.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:alhaji_user_app/views/order/order-page.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key key}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  SessionProvider sessionProvider;
  AuthProvider authProvider;
  @override
  Widget build(BuildContext context) {
    sessionProvider = Provider.of<SessionProvider>(context);
    authProvider = Provider.of(context);
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(image: AssetImage('assets/images/profile.png'))),
            ),
            SizedBox(height: 17),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                  (sessionProvider.currentUser.firstName ?? '') + ' ' + (sessionProvider.currentUser.secondName ?? ''),
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('@' + sessionProvider.currentUser.userName,
                  style: TextStyle(color: Commons.greyAccent4, fontSize: 13)),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Image.asset('assets/images/my-orders-icon.png', width: 28),
              title:
              Text('My Orders', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage(showBack: true)));
              },
            ),
            ListTile(
              leading: Image.asset('assets/images/profile-icon.png', width: 28),
              title:
              Text('My Profile', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Image.asset('assets/images/wallet-icon.png', width: 28),
              title: Text('Payment Methods',
                  style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              onTap: () {},
            ),
            ListTile(
              leading: Image.asset('assets/images/reward-icon.png', width: 28),
              title: Text('Your Rewards',
                  style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.pushNamed(context, '/rewards');
              },
            ),
            ListTile(
              leading: Image.asset('assets/images/settings-icon.png', width: 28),
              title: Text('Settings', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              onTap: () {
                AppSettings.openAppSettings();
              },
            ),
            ListTile(
              leading: Image.asset('assets/images/help-icon.png', width: 25),
              title: Text('Help & FAQ\'s',
                  style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
              onTap: () {},
            ),
            Spacer(),
            Row(
              children: [
                InkWell(
                    onTap: () async {
                      await authProvider.auth.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Commons.bgColor,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Commons.bgColor)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.power_settings_new_rounded,
                              color: Commons.bgColor,
                            ),
                          ),
                          Text(' Log Out  ',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                        ]))),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
