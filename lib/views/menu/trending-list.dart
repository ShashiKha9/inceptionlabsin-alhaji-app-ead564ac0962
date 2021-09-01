import 'package:alhaji_user_app/provider/menu.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/provider/wishlist.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:alhaji_user_app/views/details/combo-details.dart';
import 'package:alhaji_user_app/views/details/product-details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrendingOrderPage extends StatefulWidget {
  @override
  _TrendingOrderPageState createState() => _TrendingOrderPageState();
}

class _TrendingOrderPageState extends State<TrendingOrderPage> {
  BoxShadow boxShadow =
      BoxShadow(color: Colors.grey.withOpacity(.4), blurRadius: 10, spreadRadius: 2, offset: Offset(4.0, 4.0));
  MenuProvider menuProvider;
  WishListProvider wishListProvider;
  SessionProvider sessionProvider;
  String tapId;
  @override
  Widget build(BuildContext context) {
    menuProvider = Provider.of<MenuProvider>(context);
    wishListProvider = Provider.of<WishListProvider>(context);
    sessionProvider = Provider.of<SessionProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          topBar(),
          Container(
            margin: EdgeInsets.fromLTRB(25, 25, 20, 10),
            width: MediaQuery.of(context).size.width,
            child: Text('${menuProvider.trendingOrders.length} Items',
                style: TextStyle(color: Commons.greyAccent3, fontSize: 18)),
          ),
          // Row(
          //   children: [
          //     SizedBox(width: 25),
          //     Text('Sort by: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          //     Text('Price - high to low',
          //         style: TextStyle(color: Commons.bgColor, fontWeight: FontWeight.w500, fontSize: 14)),
          //     SizedBox(width: 25),
          //   ],
          // ),
          Expanded(
            child: ListView(
              children: [
                for (int i = 0; i < menuProvider.trendingOrders.length; i++) itemCard(menuProvider.trendingOrders[i])
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Todo API Integration and "Wishlist Provider"
  Widget likeButton(CommonProduct commonProduct) {
    String code = commonProduct.product != null ? commonProduct.product.productCode : commonProduct.combo.comboCode;
    return InkWell(
        onTap: () {
          setState(() {
            tapId = code;
          });
          wishListProvider.updateWishList(sessionProvider.bearer, sessionProvider.currentUser.customerCode,
              sessionProvider.currentBranch.branchCode,
              product: commonProduct.product, combo: commonProduct.combo);
        },
        child: wishListProvider.isLoading && tapId == code
            ? Container(
                width: 35,
                height: 35,
                padding: EdgeInsets.fromLTRB(4, 8, 4, 6),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.white),
                child: Image.asset("assets/images/heart.gif"))
            : Container(
                width: 35,
                height: 35,
                padding: EdgeInsets.fromLTRB(8, 10, 8, 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color:
                        !wishListProvider.isProductAvailable(product: commonProduct.product, combo: commonProduct.combo)
                            ? Colors.black38
                            : Commons.bgColor),
                child: Image.asset(
                  'assets/images/heart-icon.png',
                  color: Colors.white,
                ),
              ));
  }

  Widget itemCard(CommonProduct product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: InkWell(
        onTap: () {
          if (product.combo != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ComboDetailsScreen(combo: product.combo)));
          }
          if (product.product != null) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product.product)));
          }
        },
        child: Stack(children: [
          Container(
            width: MediaQuery.of(context).size.width - 50,
            height: (MediaQuery.of(context).size.width / 2) + 60,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [boxShadow]),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            height: (MediaQuery.of(context).size.width / 2) - 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: NetworkImage(product.product != null ? product.product.images[0] : product.combo.images[0]),
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(top: 10, right: 10, child: likeButton(product)),
          Positioned(
              bottom: 68,
              left: 18,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(40), boxShadow: [boxShadow]),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      '4.5 ',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.star, color: Commons.yellowColor, size: 15)
                  ]))),
          Positioned(
              top: MediaQuery.of(context).size.width / 2,
              left: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.product != null ? product.product.name : product.combo.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 10),
                  Text(product.product != null ? product.product.shortDescription : product.combo.shortDescription,
                      style: TextStyle(color: Commons.greyAccent4, fontWeight: FontWeight.w500, fontSize: 14)),
                ],
              ))
        ]),
      ),
    );
  }

  Widget topBar() {
    return Stack(
      children: [
        Container(height: 220, width: MediaQuery.of(context).size.width),
        Positioned(right: -5, top: -5, child: Image.asset('assets/images/beef-plate.png', width: 200)),
        Positioned(
            top: 100,
            left: 15,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Food', style: TextStyle(fontSize: 55, color: Commons.bgColor, fontWeight: FontWeight.bold)),
              Text('Trending',
                  style: TextStyle(fontSize: 55, color: Commons.colorFromHex('#565E54'), fontWeight: FontWeight.bold))
            ])),
        Positioned(
            top: 45,
            right: 20,
            child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {},
                child: Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(14),
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.11),
                          blurRadius: 10, // soften the shadow
                          spreadRadius: 2, //extend the shadow
                          offset: Offset(4.0, 4.0))
                    ]),
                    child: Image.asset('assets/images/filter-icon.png')))),
        Positioned(
            top: 45,
            left: 15,
            child: InkWell(
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
                    child: Icon(Icons.arrow_back_ios_rounded, size: 16, color: Colors.black)))),
      ],
    );
  }
}
