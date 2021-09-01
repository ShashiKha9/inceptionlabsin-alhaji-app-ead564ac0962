import 'package:alhaji_user_app/utils/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnlockedRewardScreen extends StatefulWidget {
  @override
  _UnlockedRewardScreenState createState() => _UnlockedRewardScreenState();
}

class _UnlockedRewardScreenState extends State<UnlockedRewardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(CupertinoIcons.xmark, size: 20)),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 1),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 120,
              height: MediaQuery.of(context).size.width - 130,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/reward-sample.png'), fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Spacer(flex: 1),
          Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width - 60,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Image.asset('assets/images/reward.png', width: 50),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text('Congrats 😊',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text('Earned 10% off on Feb 5, 2021 for ordering 10 times!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Commons.greyAccent3,
                        fontSize: 14,
                        // fontWeight: FontWeight.w600,
                      )),
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
