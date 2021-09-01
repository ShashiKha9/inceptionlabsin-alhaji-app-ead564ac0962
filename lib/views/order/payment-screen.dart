// import 'package:alhaji_user_app/provider/cart.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stripe_payment/stripe_payment.dart';
//
// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   CartProvider cartProvider;
//   CreditCard card;
//
//   @override
//   initState() {
//     super.initState();
//     cartProvider = Provider.of<CartProvider>(context, listen: false);
//     String publishKey;
//     if (cartProvider.orderDetail != null) {
//       publishKey = cartProvider.orderDetail.secret;
//     }
//
//     try {
//       print(">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<");
//       print(publishKey);
//       StripePayment.setOptions(StripeOptions(
//           publishableKey:
//               "pk_test_51BTUDGJAJfZb9HEBwDg86TN1KNprHjkfipXmEDMb0gSCassK5T3ZfxsAbcgKVmAIXF7oZ6ItlZZbXO6idTHE67IM007EwQ4uN3",
//           androidPayMode: 'test'));
//       print(">>>Success<<<");
//     } catch (e) {
//       print('error => $e');
//     }
//   }
//
//   confirmDialog(String clientSecret, PaymentMethod paymentMethod) {
//     var confirm = AlertDialog(
//       title: Text("Confirm Payement"),
//       content: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Text(
//               "Make Payment",
//               // style: TextStyle(fontSize: 25),
//             ),
//             Text("Charge amount:\$100")
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         new RaisedButton(
//           child: new Text('CANCEL'),
//           onPressed: () {
//             Navigator.of(context).pop();
//             final snackBar = SnackBar(
//               content: Text('Payment Cancelled'),
//             );
//             Scaffold.of(context).showSnackBar(snackBar);
//           },
//         ),
//         new RaisedButton(
//           child: new Text('Confirm'),
//           onPressed: () {
//             Navigator.of(context).pop();
//             confirmPayment(clientSecret, paymentMethod); // function to confirm Payment
//           },
//         ),
//       ],
//     );
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return confirm;
//         });
//   }
//
//   confirmPayment(String sec, PaymentMethod paymentMethod) {
//     StripePayment.confirmPaymentIntent(
//       PaymentIntent(clientSecret: sec, paymentMethodId: paymentMethod.id),
//     ).then((val) {
//       final snackBar = SnackBar(content: Text('Payment Successfull'));
//       Scaffold.of(context).showSnackBar(snackBar);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     cartProvider = Provider.of<CartProvider>(context);
//     return Scaffold(
//       key: _scaffoldKey,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 100),
//               Center(
//                 child: FlatButton(
//                     color: Colors.green,
//                     onPressed: () async {
//                       print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
//                       print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
//                       StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
//                         print('payment method: ${paymentMethod.id}');
//                         setState(() {
//                           card = paymentMethod.card;
//                         });
//                         StripePayment.confirmPaymentIntent(
//                           PaymentIntent(
//                             clientSecret: "sk_test_tR3PYbcVNZZ796tH88S4VQ2u",
//                             paymentMethodId: paymentMethod.id,
//                           ),
//                         ).then((paymentIntent) {
//                           print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
//                           print(paymentIntent.status);
//                           print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
//                           _scaffoldKey.currentState
//                               .showSnackBar(SnackBar(content: Text('Received ${paymentIntent.status}')));
//                         });
//
//                         // StripePayment.confirmPaymentIntent(intent)
//                         // double amount = 100 * 100.0;
//                         // // INTENT.call(<String, dynamic>{'amount': amount, 'currency': 'usd'}).then((response) {
//                         // confirmDialog('pi_3JRis0G5QytFqn4g1zBzTmWZ_secret_ovgkgFk3RAXkIPItQ0VXXYGXA',
//                         //     paymentMethod); //function for confirmation for payment
//                         // // });
//                         // sk_test_tR3PYbcVNZZ796tH88S4VQ2u
//                       });
//                     },
//                     child: Text(
//                       'PAY',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     )),
//               ),
//               // RaisedButton(
//               //   child: Text("Create Token with Card"),
//               //   onPressed: () {
//               //     StripePayment.createTokenWithCard(
//               //       card,
//               //     ).then((token) {
//               //       _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
//               //       // setState(() {
//               //       //   _paymentToken = token;
//               //       // });
//               //     });
//               //   },
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
