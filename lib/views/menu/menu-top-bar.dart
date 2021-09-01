import 'package:alhaji_user_app/utils/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget MenuTopBar(BuildContext context, String branch) {
  return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 80,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Builder(
            builder: (BuildContext context) => InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.11),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(4.0, 4.0))
                    ]),
                    child: Image.asset('assets/images/drawer-icon.png')))),
        Container(
            width: (MediaQuery.of(context).size.width - 152),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                showDialogue(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('    Ordering on',
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                    Icon(CupertinoIcons.chevron_down, color: Colors.black, size: 16)
                  ]),
                  SizedBox(height: 3),
                  Text(branch ?? '',
                      style: TextStyle(color: Commons.bgColor, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            )),
        InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Container(
                width: 42,
                height: 42,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.11),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(4.0, 4.0))
                    ],
                    image: DecorationImage(image: AssetImage('assets/images/profile.png')))))
      ]));
}

showDialogue(BuildContext context) {
  print('tapped');
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Are you sure, to change the branch?', style: TextStyle(color: Commons.bgColor)),
      content: Text('Some of the product in this branch may not available in other branch.',
          style: TextStyle(color: Commons.greyAccent3)),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
        FlatButton(
            onPressed: () => Navigator.pushNamed(context, '/branches'),
            child: Text('Yes', style: TextStyle(color: Commons.bgColor, fontWeight: FontWeight.bold))),
      ],
    ),
  );
}
