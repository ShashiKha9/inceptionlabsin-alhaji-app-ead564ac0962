import 'package:alhaji_user_app/provider/cart.dart';
import 'package:alhaji_user_app/provider/search-filter.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:alhaji_user_app/utils/product-cards/product-card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  CartProvider cartProvider;
  SessionProvider sessionProvider;
  SearchFilterProvider searchFilterProvider;

  @override
  void initState() {
    super.initState();
    searchFilterProvider = Provider.of<SearchFilterProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => searchFilterProvider.clear());
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);
    sessionProvider = Provider.of<SessionProvider>(context);
    searchFilterProvider = Provider.of<SearchFilterProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(height: MediaQuery.of(context).size.height),
          Column(
            children: [
              SizedBox(height: 40),
              topBar(),
              searchBar(),
              if (searchFilterProvider.isLoading)
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: CircularProgressIndicator(color: Commons.bgColor),
                ),
              if (searchFilterProvider.productList != null && !searchFilterProvider.isLoading)
                Expanded(
                    child: searchFilterProvider.productList.isNotEmpty
                        ? ListView(
                            children: [
                              for (int index = 0; index < searchFilterProvider.productList.length; index++)
                                ProductCard(product: searchFilterProvider.productList[index]),
                              if (cartProvider.cartProducts.isNotEmpty) SizedBox(height: 100),
                            ],
                          )
                        : Text("No Product Found"))
              else if (searchFilterProvider.productList == null && !searchFilterProvider.isLoading)
                Expanded(child: Text("No Product Found"))
            ],
          ),
          if (cartProvider.cartProducts.isNotEmpty)
            Positioned(
                bottom: 10,
                child: InkWell(
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
                                  decoration:
                                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black,
                                    size: 20,
                                  ))
                            ])
                          ])),
                ))
        ],
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: (MediaQuery.of(context).size.width - 95),
              decoration: BoxDecoration(color: Commons.greyAccent1, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Container(
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 3),
                    child: Image.asset('assets/images/search-icon.png', width: 15)),
                Container(
                    width: MediaQuery.of(context).size.width - 130,
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Find Your Food...',
                          hintStyle: TextStyle(color: Commons.greyAccent2, fontSize: 14)),
                      onChanged: (value) {
                        if (value.length >= 3)
                          searchFilterProvider.searchProducts(
                              value, sessionProvider.bearer, sessionProvider.currentBranch.branchCode);
                      },
                    ))
              ])),
          InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.pushNamed(context, '/filter');
              },
              child: Container(
                  width: 42,
                  height: 42,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(.11), blurRadius: 10, spreadRadius: 2, offset: Offset(4.0, 4.0))
                  ]),
                  child: Image.asset('assets/images/filter-icon.png')))
        ],
      ),
    );
  }

  Widget topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.11), blurRadius: 2, spreadRadius: 1, offset: Offset(4.0, 4.0))
                ]),
                child: Icon(Icons.arrow_back_ios_rounded, size: 20, color: Colors.black))),
        Text('Search Food', style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600)),
        Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: AssetImage('assets/images/profile.png'))),
        ),
      ]),
    );
  }
}
