import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'constants.dart';

class CheckoutPage extends StatefulWidget{
  final String sessionId;

  const CheckoutPage({Key key, this.sessionId}) : super(key: key);

  CheckoutPageState createState()=> CheckoutPageState();
}
class CheckoutPageState extends State<CheckoutPage> {
  WebViewController _WebViewController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController)=>_WebViewController,
        onPageFinished: (String url) { //<---- add this
          if (url == initialUrl) {
            _redirectToStripe();
          }
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://success.com')) {
            Navigator.of(context).pop('success'); // <-- Handle success case
          } else if (request.url.startsWith('https://cancel.com')) {
            Navigator.of(context).pop('cancel'); // <-- Handle cancel case
          }
          return NavigationDecision.navigate;
        },
      ),

    );
  }
  String get initialUrl =>  'data:text/html;base64,${base64Encode(Utf8Encoder().convert(kStripeHtmlPage))}';
  Future<void> _redirectToStripe() async {
    //<--- prepare the JS in a normal string
    final redirectToCheckoutJs = '''
var stripe = Stripe(\'$apiKey\');
    
stripe.redirectToCheckout({
  sessionId: '${widget.sessionId}'
}).then(function (result) {
  result.error.message = 'Error'
});
''';
    try {
      await _WebViewController.evaluateJavascript(redirectToCheckoutJs);
    } on PlatformException catch (e) {
      if (!e.details.contains(
          'JavaScript execution returned a result of an unsupported type')) {
        rethrow;
      }
    }
  }
}



const String kStripeHtmlPage ='''
<!DOCTYPE html>
<html>
<script src="https://js.stripe.com/v3/"></script>
<head><title>Stripe checkout</title></head>
<body>
Stripe checkout template.
</body>
</html>
''';