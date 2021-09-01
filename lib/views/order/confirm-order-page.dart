import 'package:alhaji_user_app/provider/cart.dart';
import 'package:alhaji_user_app/provider/menu.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:alhaji_user_app/views/order/order-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConfirmOrderPage extends StatefulWidget {
  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  SessionProvider sessionProvider;
  CartProvider cartProvider;
  MenuProvider menuProvider;
  bool showSuccess = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  onSuccess() async {
    setState(() {
      showSuccess = true;
    });
    await Future.delayed(const Duration(seconds: 3), navigate).then((value) {
      cartProvider.clearCart();
      menuProvider.reload(sessionProvider.bearer, sessionProvider.currentBranch.branchCode);
    });
    // navigate();
  }

  navigate() async {
    // Navigator.pushNamed(context, "/stripe");
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    Navigator.push(context, MaterialPageRoute(builder: (contex) => OrdersPage(showBack: true)));
  }

  @override
  Widget build(BuildContext context) {
    sessionProvider = Provider.of<SessionProvider>(context);
    cartProvider = Provider.of<CartProvider>(context);
    menuProvider = Provider.of<MenuProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      body: showSuccess
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: MediaQuery.of(context).size.width - 140,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/success.gif'), fit: BoxFit.cover)),
                  ),
                ),
                Text('Order Placed',
                    style: TextStyle(color: Commons.textColor, fontSize: 24, fontWeight: FontWeight.w600)),
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/stripe");
                    },
                    child: Text("press here"))
              ],
            )
          : cartProvider.isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator(color: Commons.bgColor)),
                    Center(
                      child: Text('Placing Order',
                          style: TextStyle(color: Commons.textColor, fontSize: 24, fontWeight: FontWeight.w600)),
                    )
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 35),
                      topBar(context),
                      Container(
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Commons.colorFromHex('#F2F2F2'), borderRadius: BorderRadius.circular(35)),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text('Customer Contact Info',
                                style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600)),
                            SizedBox(height: 10),
                            Divider(thickness: 1, indent: 15, endIndent: 15),
                            mobileField(),
                            nameField(),
                            mailField(),
                            postalCodeField(),
                            SizedBox(height: 15),
                            InkWell(
                              onTap: () async {
                                if (cartProvider.cartProducts.isNotEmpty) {
                                  await cartProvider
                                      .checkout(sessionProvider.currentUser.toJson(edit: true),
                                          sessionProvider.currentBranch.toJson(), sessionProvider.bearer, scaffoldKey)
                                      .then((value) {
                                    if (value) {
                                      onSuccess();
                                    }
                                  });
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.all(15),
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width - 120,
                                  decoration:
                                      BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(100)),
                                  child: Text('CONFIRM ORDER',
                                      style:
                                          TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget mailField() {
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(10, 25, 10, 10),
            child: Text('Email Id (Optional)',
                style: TextStyle(color: Commons.colorFromHex('#7C7C7C'), fontSize: 18, fontWeight: FontWeight.w600))),
        Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: TextFormField(
                initialValue: sessionProvider?.currentUser?.emailId ?? '',
                style: TextStyle(color: Commons.textColor, fontSize: 16),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Mail Id',
                    hintStyle: TextStyle(color: Commons.greyAccent2, fontSize: 16))))
      ],
    );
  }

  Widget postalCodeField() {
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(10, 25, 10, 10),
            child: Text('Postal Code',
                style: TextStyle(color: Commons.colorFromHex('#7C7C7C'), fontSize: 18, fontWeight: FontWeight.w600))),
        Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: TextFormField(
                initialValue: sessionProvider.currentUser?.pincode ?? '',
                style: TextStyle(color: Commons.textColor, fontSize: 16),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Postal Code',
                    hintStyle: TextStyle(color: Commons.greyAccent2, fontSize: 16))))
      ],
    );
  }

  Widget nameField() {
    return Column(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(10, 25, 10, 10),
          child: Text('Full Name',
              style: TextStyle(color: Commons.colorFromHex('#7C7C7C'), fontSize: 18, fontWeight: FontWeight.w600))),
      Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Container(
                width: MediaQuery.of(context).size.width / 2 - 52,
                child: TextFormField(
                    initialValue: sessionProvider.currentUser?.firstName,
                    style: TextStyle(color: Commons.textColor, fontSize: 16),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'First',
                        hintStyle: TextStyle(color: Commons.greyAccent2, fontSize: 16)))),
            Spacer(),
            Container(height: 25, width: 1, color: Commons.greyAccent3),
            Spacer(),
            Container(
                width: MediaQuery.of(context).size.width / 2 - 52,
                child: TextFormField(
                    initialValue: sessionProvider.currentUser?.secondName ?? '',
                    style: TextStyle(color: Commons.textColor, fontSize: 16),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Last',
                        hintStyle: TextStyle(color: Commons.greyAccent2, fontSize: 16))))
          ]))
    ]);
  }

  Widget mobileField() {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Text('Mobile Number',
            style: TextStyle(color: Commons.colorFromHex('#7C7C7C'), fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Text(' +44', style: TextStyle(color: Commons.greyAccent2, fontSize: 16)),
            Spacer(),
            Container(
                width: MediaQuery.of(context).size.width - 140,
                child: TextFormField(
                    initialValue: sessionProvider.currentUser?.phoneNumbers[0]?.phoneNumber ?? '',
                    style: TextStyle(color: Commons.textColor, fontSize: 16),
                    decoration: InputDecoration(border: InputBorder.none, counterText: ''),
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly])),
            Spacer()
          ]))
    ]);
  }

  Widget topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.11),
                      blurRadius: 10, // soften the shadow
                      spreadRadius: 2, //extend the shadow
                      offset: Offset(
                        4.0,
                        4.0,
                      ))
                ]),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 20,
                  color: Colors.black,
                )),
          ),
          Text(
            'Payment Contact Info',
            style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            '..',
            style: TextStyle(color: Commons.greyAccent3, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
