import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Commons {
  static String baseURL = 'https://api.alhajisuya.com/api/';
  static const hintColor = Color(0xFF4D0F29);
  static Color bgColor = Commons.colorFromHex('#489733');
  static Color textColor = Commons.colorFromHex('#363636');
  static Color yellowColor = Commons.colorFromHex('#FFC529');
  static Color bgLightColor = Commons.colorFromHex('#b6ebb2');

  static Color greyAccent1 = Commons.colorFromHex('#F3F3F3');
  static Color greyAccent2 = Commons.colorFromHex('#cccccc');
  static Color greyAccent3 = Commons.colorFromHex('#999999');
  static Color greyAccent4 = Commons.colorFromHex('#8e8e93');
  static Color greyAccent5 = Commons.colorFromHex('#333333');

  static Color colorFromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Widget topBar(BuildContext context, {bool showBackButton = false}) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
        ),
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(100)),
          ),
        ),
        Positioned(top: -50, left: -75, child: innerCircle()),
        Positioned(
          top: -100,
          left: 0,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(color: Commons.bgLightColor, borderRadius: BorderRadius.circular(100)),
          ),
        ),
        if (showBackButton) Positioned(top: 65, left: 30, child: backButton(context))
      ],
    );
  }

  static Widget backButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 2, offset: Offset(2.0, 2.0))
          ],
        ),
        child: Icon(Icons.navigate_before_rounded, color: Colors.black),
      ),
    );
  }

  static Widget innerCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(100)),
        ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
        ),
      ],
    );
  }

  static Future<bool> onWillPop(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?', style: TextStyle(color: Commons.bgColor)),
            content: Text('Do you want to exit an App', style: TextStyle(color: Commons.greyAccent4)),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
              FlatButton(
                  onPressed: () => exit(0),
                  child: Text('Yes', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
            ],
          ),
        ) ??
        false;
  }
}
