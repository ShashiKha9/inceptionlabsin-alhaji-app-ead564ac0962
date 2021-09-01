

import 'package:alhaji_user_app/checkout.dart';
import 'package:alhaji_user_app/serverstub.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stripe Checkout Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (_) => PaymentScreen(),
        '/success': (_) => SuccessPage(),
      },
    );
  }
}

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Stripe"),
    ),
    body: Builder(
      builder: (context) => Center(
        child: RaisedButton(onPressed: () async{
          final sessionId = await Server().createCheckout();
        await  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>CheckoutPage(sessionId: sessionId,)));
          final snackbar = SnackBar(content: Text('SessionId : $sessionId'));
          Scaffold.of(context).showSnackBar(snackbar);
          
          
        },
        child: Text("Stripe Checkout"),),
      ),
    )
  );
  }







}
class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Success',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}