import 'package:alhaji_user_app/utils/commons.dart';
import 'package:alhaji_user_app/views/rewards/unlocked-reward.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Rewards extends StatefulWidget {
  @override
  _RewardsState createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            topBar(),
            progressCard(),
            Expanded(
              child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  padding: const EdgeInsets.all(25),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  children: [
                    rewardCard(scaffoldKey, unlocked: true),
                    rewardCard(scaffoldKey),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Widget rewardCard(GlobalKey<ScaffoldState> scaffoldkey, {bool unlocked = false}) {
    return InkWell(
      onTap: () {
        if (!unlocked) {
          scaffoldkey.currentState
              .showSnackBar(SnackBar(content: Text('Reward is locked'), duration: Duration(milliseconds: 1000)));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UnlockedRewardScreen()));
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/reward-sample.png'), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20)),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.black87.withOpacity(.7), borderRadius: BorderRadius.circular(20)),
          ),
          if (!unlocked)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/lock-icon.png', width: 25),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text('Unlock 20% by making 20 Orders',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Commons.greyAccent3,
                        fontSize: 9,
                        // fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            )
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('Level 1',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Commons.greyAccent3,
                        fontSize: 9,
                        // fontWeight: FontWeight.w600,
                      )),
                ),
                Spacer(),
                Image.asset('assets/images/reward.png', width: 60),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('Yay! You won 10% off',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Commons.greyAccent3,
                        fontSize: 9,
                        // fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            )
        ],
      ),
    );
  }

  Widget progressCard() {
    return Container(
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Commons.greyAccent2, width: .5),
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('10% Flat Offer', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14)),
            Text('6/10 Orders', style: TextStyle(color: Commons.greyAccent4, fontSize: 12, fontWeight: FontWeight.w600))
          ]),
          SizedBox(height: 10),
          Container(
              decoration: BoxDecoration(
                  color: Commons.bgColor,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Commons.bgColor, width: .5)),
              child: LinearPercentIndicator(
                  animation: true,
                  lineHeight: 3,
                  animationDuration: 2000,
                  percent: 0.6,
                  padding: EdgeInsets.symmetric(horizontal: 1.5),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  backgroundColor: Colors.white,
                  progressColor: Commons.bgColor))
        ]));
  }

  Widget topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.all(3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(.11),
                        blurRadius: 10, // soften the shadow
                        spreadRadius: 2, //extend the shadow
                        offset: Offset(4.0, 4.0))
                  ]),
                  child: Icon(Icons.arrow_back_ios_rounded, size: 16, color: Colors.black))),
          Text(
            'Your Rewards',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(image: AssetImage('assets/images/profile.png'))),
          ),
        ],
      ),
    );
  }
}
