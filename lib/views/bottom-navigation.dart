import 'package:alhaji_user_app/models/restaurant-branches.dart';
import 'package:alhaji_user_app/provider/cart.dart';
import 'package:alhaji_user_app/provider/order.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/provider/wishlist.dart';
import 'package:alhaji_user_app/utils/bottomNavigationBar.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:alhaji_user_app/views/notification/notification.dart';
import 'package:alhaji_user_app/views/wish-list/wish-list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'menu/menu-page.dart';
import 'order/order-page.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({Key key}) : super(key: key);

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _currentIndex = 0;
  PageController _pageController;
  WishListProvider wishListProvider;
  OrderProvider orderProvider;
  SessionProvider sessionProvider;
  List<Widget> pages = [MenuPage(), OrdersPage(), WishList(), NotificationPage()];

  @override
  void initState() {
    super.initState();
    wishListProvider = Provider.of<WishListProvider>(context, listen: false);
    sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) => wishListProvider.getWishList(
        sessionProvider.bearer, sessionProvider.currentUser.customerCode, sessionProvider.currentBranch.branchCode));
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => orderProvider.getOrders(sessionProvider.bearer, sessionProvider.currentUser.customerCode));
  }

  @override
  Widget build(BuildContext context) {
    wishListProvider = Provider.of<WishListProvider>(context);
    orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () => Commons.onWillPop(context),
        child: SizedBox.expand(
            child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: pages)),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('Menu'),
              textAlign: TextAlign.center,
              image: 'assets/images/home-icon.png',
              activeColor: Commons.bgColor),
          BottomNavyBarItem(
              title: Text('Order'),
              textAlign: TextAlign.center,
              image: 'assets/images/orders-icon.png',
              activeColor: Commons.bgColor,
              notificationCount: orderProvider.upComingOrder.length),
          BottomNavyBarItem(
              title: Text('Wish List'),
              textAlign: TextAlign.center,
              image: 'assets/images/heart-icon.png',
              activeColor: Commons.bgColor,
              notificationCount: wishListProvider.wishListProducts.length),
          BottomNavyBarItem(
              title: Text('Notify'),
              textAlign: TextAlign.center,
              image: 'assets/images/notification-icon.png',
              activeColor: Commons.bgColor,
              notificationCount: 0)
        ],
      ),
    );
  }
}

class Branches extends StatefulWidget {
  @override
  _BranchesState createState() => _BranchesState();
}

class _BranchesState extends State<Branches> {
  SessionProvider sessionProvider;
  CartProvider cartProvider;
  int selected;
  changeSelected(int value) {
    setState(() {
      selected = value;
    });
  }

  @override
  void initState() {
    super.initState();
    sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => sessionProvider.getBranches());
  }

  @override
  Widget build(BuildContext context) {
    sessionProvider = Provider.of<SessionProvider>(context);
    cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/blur-bg.png')))),
          Positioned(
              bottom: 40,
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Select Restaurant Takeaway',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration:
                            BoxDecoration(border: Border.all(color: Colors.blueGrey.withOpacity(.6), width: .2)),
                      ),
                      if (sessionProvider.isBranchesLoading) CircularProgressIndicator(color: Commons.bgColor),
                      if (!sessionProvider.isBranchesLoading && sessionProvider.branches != null)
                        for (int index = 0; index < sessionProvider.branches.restaurantBranches.length; index++)
                          branchCard(
                              name: sessionProvider.branches.restaurantBranches[index].name,
                              address: sessionProvider.branches.restaurantBranches[index].address,
                              branch: sessionProvider.branches.restaurantBranches[index]),
                      SizedBox(height: 10),
                      InkWell(
                          onTap: () {
                            if (sessionProvider.currentBranch != null) {
                              cartProvider.clearCart();
                              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                            }
                          },
                          child: Container(
                              padding: EdgeInsets.all(25),
                              width: MediaQuery.of(context).size.width - 110,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: sessionProvider.currentBranch != null
                                      ? Commons.bgColor
                                      : Commons.bgColor.withOpacity(.5),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Text('CONFIRM',
                                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)))),
                      SizedBox(height: 20)
                    ],
                  )))
        ],
      ),
    );
  }

  Widget branchCard({String name, String address, RestaurantBranch branch}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: InkWell(
            onTap: () {
              sessionProvider.changeCurrentBranch(branch);
            },
            child: Column(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 22,
                        height: 22,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: AssetImage('assets/images/dinning-icon.png'), fit: BoxFit.cover))),
                    Container(
                        width: MediaQuery.of(context).size.width - 170,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(name ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(address ?? '', style: TextStyle(color: Commons.bgColor, fontSize: 12))
                        ])),
                    if (sessionProvider.currentBranch != null)
                      Icon(
                          sessionProvider.currentBranch.name == name
                              ? CupertinoIcons.check_mark_circled_solid
                              : CupertinoIcons.circle,
                          size: 18,
                          color: sessionProvider.currentBranch.name == name ? Commons.bgColor : Colors.blueGrey)
                    else
                      Icon(CupertinoIcons.circle, size: 18)
                  ]),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey.withOpacity(.5), width: .2)))
            ])));
  }
}
