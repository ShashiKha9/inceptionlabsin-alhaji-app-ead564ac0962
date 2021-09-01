import 'dart:convert';
import 'dart:io';

import 'package:alhaji_user_app/Payment.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
/// Only for demo purposes!
/// Don't you dare do it in real apps!
class Server {
  Future<String> createCheckout() async {
    final auth = 'Basic ' + base64Encode(utf8.encode('$secretKey:'));
    final body = {
      'payment_method_types': ['card'],
      'line_items': [
        {
          // 'price': nikesPriceId,
          'quantity': 1,
          'currency': 'USD',
          'amount': 1500,

        }
      ],
      'mode': 'payment',
      'success_url': 'https://success.com/{CHECKOUT_SESSION_ID}',
      'cancel_url': 'https://cancel.com/',
    };

    try {
      final result = await Dio().post(
        "https://api.stripe.com/v1/payment_intents",
        data: body,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: auth},
          contentType: "application/x-www-form-urlencoded",
        ),
      );
      return result.data['id'];
    } on DioError catch (e, s) {
      print(e.response);
      throw e;
    }
  }
}
