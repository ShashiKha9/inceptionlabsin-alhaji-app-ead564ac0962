import 'package:alhaji_user_app/provider/order.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:alhaji_user_app/views/order/order-history.dart';
import 'package:alhaji_user_app/views/order/upcoming-order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  final bool showBack;
  const OrdersPage({Key key, this.showBack}) : super(key: key);
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int selectedIndex = 0;
  changeIndex(int value) {
    setState(() {
      selectedIndex = value;
    });
  }

  SessionProvider sessionProvider;
  OrderProvider orderProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    orderProvider = Provider.of<OrderProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => orderProvider.getOrders(sessionProvider.bearer, sessionProvider.currentUser.customerCode));
  }

  @override
  Widget build(BuildContext context) {
    orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 38,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.showBack != null) Commons.backButton(context),
                Text(
                  'My Orders',
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
          ),
          SizedBox(
            height: 15,
          ),
          if (orderProvider.isLoading) CircularProgressIndicator(color: Commons.bgColor),
          if (!orderProvider.isLoading) toggleButton(),
          if (!orderProvider.isLoading && selectedIndex == 0)
            UpcomingOrdersPage(orders: orderProvider?.upComingOrder ?? []),
          if (!orderProvider.isLoading && selectedIndex == 1)
            OrdersHistoryPage(
              orders: orderProvider?.historyOrder ?? [],
            ),
        ],
      ),
    );
  }

  Widget toggleButton() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.all(2),
        constraints: BoxConstraints(maxWidth: 600),
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100), border: Border.all(width: .2)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                changeIndex(0);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2 - 20,
                constraints: BoxConstraints(maxWidth: 290),
                padding: EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedIndex == 0 ? Commons.bgColor : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text('Upcoming',
                    style: TextStyle(color: selectedIndex == 0 ? Colors.white : Colors.black, fontSize: 16)),
              ),
            ),
            GestureDetector(
              onTap: () {
                changeIndex(1);
              },
              child: Container(
                padding: EdgeInsets.all(15),
                constraints: BoxConstraints(maxWidth: 290),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2 - 20,
                decoration: BoxDecoration(
                  color: selectedIndex == 1 ? Commons.bgColor : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'History',
                  style: TextStyle(color: selectedIndex == 1 ? Colors.white : Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
