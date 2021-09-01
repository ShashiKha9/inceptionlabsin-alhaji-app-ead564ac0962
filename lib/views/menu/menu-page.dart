import 'package:alhaji_user_app/provider/cart.dart';
import 'package:alhaji_user_app/provider/menu.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/utils/product-cards/combo-card.dart';
import 'package:alhaji_user_app/utils/product-cards/product-card.dart';
import 'package:alhaji_user_app/views/menu/menu-drawer.dart';
import 'package:alhaji_user_app/views/menu/trending-order-item-card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utils/commons.dart';
import 'menu-top-bar.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int currentMenuIndex = 0;
  changeMenuIndex(int value) {
    setState(() {
      currentMenuIndex = value;
    });
  }

  CartProvider cartProvider;
  MenuProvider menuProvider;
  SessionProvider sessionProvider;
  @override
  void initState() {
    sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    menuProvider = Provider.of<MenuProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) => menuProvider.getCategories(sessionProvider.bearer));
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => menuProvider.getProducts(sessionProvider.bearer, sessionProvider.currentBranch.branchCode));
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => menuProvider.getCombos(sessionProvider.bearer, sessionProvider.currentBranch.branchCode));
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => menuProvider.getTrendingOrders(sessionProvider.bearer, sessionProvider.currentBranch.branchCode));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    menuProvider = Provider.of<MenuProvider>(context);
    sessionProvider = Provider.of<SessionProvider>(context);
    cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MenuTopBar(context, sessionProvider.currentBranch.name),
      drawer: MenuDrawer(),
      body: menuProvider.isCategoriesLoading
          ? Center(child: CircularProgressIndicator(color: Commons.bgColor))
          : Stack(
              alignment: Alignment.center,
              children: [
                /// Categories field
                Column(children: [
                  searchCard(),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        for (int index = 0; index < menuProvider.categoriesList.result.length; index++)
                          menuItemCard(
                              title: menuProvider.categoriesList.result[index].name,
                              image: menuProvider.categoriesList.result[index].imgUrl,
                              selectedItem: index == currentMenuIndex,
                              onTap: () => changeMenuIndex(index))
                      ])),
                  Divider(height: 8, color: Colors.grey.withOpacity(.4), thickness: 2.5),
                  SizedBox(height: 12),

                  /// Selected Category Name
                  if (!menuProvider.isCategoriesLoading && menuProvider.categoriesList != null)
                    Container(
                        width: (menuProvider.categoriesList.result[currentMenuIndex].name.length * 16).toDouble(),
                        child: Column(children: [
                          Text(menuProvider.categoriesList.result[currentMenuIndex].name,
                              style: TextStyle(color: Commons.textColor, fontWeight: FontWeight.w600, fontSize: 22)),
                          Divider(height: 8, color: Commons.bgColor, thickness: 3),
                          SizedBox(height: 10)
                        ])),

                  /// products List
                  if (menuProvider.categoriesList != null &&
                      menuProvider.productList != null &&
                      !menuProvider.isProductsLoading)
                    Expanded(
                      child: ListView(
                        children: [
                          if (menuProvider.categoriesList.result[currentMenuIndex].name.toLowerCase() != 'meals')
                            for (int index = 0; index < menuProvider.productList.productsList.length; index++)
                              if (menuProvider.categoriesList.result[currentMenuIndex].categoryCode ==
                                  menuProvider.productList.productsList[index].categoryCode)
                                ProductCard(product: menuProvider.productList.productsList[index]),

                          if (menuProvider.categoriesList.result[currentMenuIndex].name.toLowerCase() == 'meals')
                            if (menuProvider.combosList?.combosList != null)
                              for (int index = 0; index < menuProvider.combosList.combosList.length; index++)
                                ComboCard(combo: menuProvider.combosList.combosList[index]),

                          /// Trending Orders List
                          if (menuProvider.trendingOrders.isNotEmpty)
                            Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text('Trending Orders',
                                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800)),
                                  InkWell(
                                    onTap: () => Navigator.pushNamed(context, '/trending'),
                                    child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text('View All',
                                            style: TextStyle(
                                                color: Commons.bgColor, fontSize: 14, fontWeight: FontWeight.w800))),
                                  )
                                ])),
                          if (menuProvider.trendingOrders.isNotEmpty)
                            Container(
                                height: 160,
                                child: ListView(scrollDirection: Axis.horizontal, children: [
                                  for (int i = 0; i < menuProvider.trendingOrders.length && i <= 5; i++)
                                    TrendingItemCard(
                                        product: menuProvider.trendingOrders[i]?.product ?? null,
                                        combo: menuProvider.trendingOrders[i]?.combo ?? null)
                                ])),
                          if (cartProvider.cartProducts.isNotEmpty) SizedBox(height: 80)
                        ],
                      ),
                    )
                ]),
                if (cartProvider.cartProducts.isNotEmpty) Positioned(bottom: 10, child: cartDetailsCard())
              ],
            ),
    );
  }

  Widget cartDetailsCard() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/cart');
      },
      child: Container(
          width: MediaQuery.of(context).size.width - 50,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(20)),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width - 250,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(' ${cartProvider.cartProducts.length} ITEM',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                      SizedBox(height: 10),
                      Text('£ ${cartProvider.totalCartAmount}',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    ])),
                Row(children: [
                  Text('View Cart ', style: TextStyle(color: Colors.white, fontSize: 13)),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                      child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20))
                ])
              ])),
    );
  }

  Widget menuItemCard(
      {@required String title, @required String image, bool selectedItem = false, @required Function onTap}) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.fromLTRB(10, 15, 10, 20),
            height: 107,
            decoration: BoxDecoration(
              color: selectedItem ? Commons.bgColor : Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                    color: Colors.blueGrey.withOpacity(.1), blurRadius: 15, spreadRadius: 5, offset: Offset(4.0, 6.0)),
              ],
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(image: NetworkImage(image))),
              ),
              SizedBox(height: 12),
              Text(title,
                  style: TextStyle(
                      color: selectedItem ? Colors.white : Commons.greyAccent4,
                      fontSize: title.length > 6 ? 10.5 : 13,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 18)
            ])));
  }

  Widget searchCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
            width: (MediaQuery.of(context).size.width - 90),
            decoration: BoxDecoration(color: Commons.greyAccent1, borderRadius: BorderRadius.circular(10)),
            child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                },
                child: Row(children: [
                  Container(
                      padding: EdgeInsets.only(left: 8, right: 8, bottom: 3),
                      child: Image.asset('assets/images/search-icon.png', width: 15)),
                  Container(
                      width: MediaQuery.of(context).size.width - 185,
                      child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              enabled: false,
                              hintText: 'Find Your Food...',
                              hintStyle: TextStyle(color: Commons.greyAccent2, fontSize: 14))))
                ]))),
        InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.pushNamed(context, '/search');
              Navigator.pushNamed(context, '/filter');
            },
            child: Container(
                width: 42,
                height: 42,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.11), blurRadius: 10, spreadRadius: 2, offset: Offset(4.0, 4.0))
                ]),
                child: Image.asset('assets/images/filter-icon.png')))
      ]),
    );
  }
}
