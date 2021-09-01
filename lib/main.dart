 import 'package:alhaji_user_app/Payment.dart';
import 'package:alhaji_user_app/provider/cart.dart';
import 'package:alhaji_user_app/provider/menu.dart';
import 'package:alhaji_user_app/provider/order.dart';
import 'package:alhaji_user_app/provider/search-filter.dart';
import 'package:alhaji_user_app/provider/wishlist.dart';
import 'package:alhaji_user_app/views/menu/trending-list.dart';
import 'package:alhaji_user_app/views/order/cart-page.dart';
import 'package:alhaji_user_app/views/order/confirm-order-page.dart';
// import 'package:alhaji_user_app/views/order/payment-screen.dart';
import 'package:alhaji_user_app/views/rewards/rewards.dart';
import 'package:alhaji_user_app/views/search/filter-screen.dart';
import 'package:alhaji_user_app/views/search/search-screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/provider/session.dart';
import '/views/login/register-form.dart';
import '/views/profile-page.dart';
import 'provider/auth.dart';
import 'utils/app-theme.dart';
import 'views/bottom-navigation.dart';
import 'views/login/login-page.dart';
import 'views/splash-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
   home:   MyApp1()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => SessionProvider()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => WishListProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => SearchFilterProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: appTheme,
          // home: PaymentScreen(),
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            '/splash': (BuildContext context) => SplashScreen(),
            '/login': (BuildContext context) => LoginPage(),
            '/home': (BuildContext context) => BottomNavigationPage(),
            '/profile': (BuildContext context) => RegisteredProfilePage(),
            '/registration': (BuildContext context) => RegistrationPage(),
            '/branches': (BuildContext context) => Branches(),
            '/cart': (BuildContext context) => CartScreen(),
            '/payment': (BuildContext context) => ConfirmOrderPage(),
            '/trending': (BuildContext context) => TrendingOrderPage(),
            '/rewards': (BuildContext context) => Rewards(),
            '/search': (BuildContext context) => SearchScreen(),
            '/filter': (BuildContext context) => FilterScreen(),
            // '/stripe': (BuildContext context) => PaymentScreen(),
          }),
    );
  }
}
