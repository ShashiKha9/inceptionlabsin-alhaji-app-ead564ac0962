import 'dart:ui';

import 'package:alhaji_user_app/views/login/register-form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/provider/session.dart';
import '/utils/commons.dart';

class RegisteredProfilePage extends StatefulWidget {
  @override
  _RegisteredProfilePageState createState() => _RegisteredProfilePageState();
}

class _RegisteredProfilePageState extends State<RegisteredProfilePage> {
  SessionProvider _sessionProvider;
  @override
  Widget build(BuildContext context) {
    _sessionProvider = Provider.of<SessionProvider>(context);
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      Commons.topBar(context, showBackButton: true),
      profileField(),
      SizedBox(
        height: 10,
      ),
      Text(
        _sessionProvider.currentUser.userName,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext contexr) => RegistrationPage(user: _sessionProvider.currentUser)));
              },
              radius: 100,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40), border: Border.all(color: Commons.greyAccent3)),
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 15),
                      Text('EDIT', style: TextStyle(fontSize: 12)),
                    ],
                  )))
        ],
      ),
      Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        constraints: BoxConstraints(minWidth: 250, maxWidth: 600),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Commons.greyAccent3)),
        child: Column(
          children: [
            textField(
                initialValue: _sessionProvider.currentUser.firstName + ' ' + _sessionProvider.currentUser.secondName,
                title: 'Full Name'),
            textField(initialValue: _sessionProvider.currentUser.emailId, title: 'Email'),
            textField(initialValue: _sessionProvider.currentUser.phoneNumbers[0].phoneNumber, title: 'Phone Number'),
            textField(initialValue: _sessionProvider.currentUser.pincode, title: 'Area Code'),
            textField(initialValue: '@' + _sessionProvider.currentUser.userName, title: 'User Name'),
          ],
        ),
      ),
      SizedBox(height: 100)
    ])));
  }

  Widget textField({String initialValue, String title}) {
    TextEditingController textEditingController = TextEditingController();
    textEditingController.text = initialValue;
    return ListTile(
        title: Text(title, style: TextStyle(fontSize: 13)),
        subtitle: TextFormField(
            cursorColor: Commons.bgColor,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            controller: textEditingController,
            decoration: InputDecoration(),
            readOnly: true,
            enabled: false));
  }

  Widget profileField() {
    return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            image: DecorationImage(image: AssetImage('assets/images/profile.png'))));
  }
}
