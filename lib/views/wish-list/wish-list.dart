import 'package:alhaji_user_app/provider/cart.dart';
import 'package:alhaji_user_app/provider/menu.dart';
import 'package:alhaji_user_app/provider/wishlist.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:alhaji_user_app/utils/product-cards/combo-card.dart';
import 'package:alhaji_user_app/utils/product-cards/product-card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  CartProvider cartProvider;
  WishListProvider wishListProvider;
  MenuProvider menuProvider;
  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);
    wishListProvider = Provider.of<WishListProvider>(context);
    menuProvider = Provider.of<MenuProvider>(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            topBar(),
            if (wishListProvider.wishListProducts.isNotEmpty && !wishListProvider.isLoading)
              Expanded(
                  child: ListView(children: [
                for (int index = wishListProvider.wishListProducts.length - 1; index >= 0; index--)
                  if (menuProvider.getComboById(wishListProvider.wishListProducts[index].product.productCode) != null)
                    ComboCard(
                        combo: menuProvider.getComboById(wishListProvider.wishListProducts[index].product.productCode))
                  else if (menuProvider.getProductById(wishListProvider.wishListProducts[index].product.productCode) !=
                      null)
                    ProductCard(
                        product:
                            menuProvider.getProductById(wishListProvider.wishListProducts[index].product.productCode)),
                if (cartProvider.cartProducts.isNotEmpty) SizedBox(height: 100),
              ]))
            else
              Expanded(
                  child: Column(
                children: [
                  Spacer(flex: 1),
                  Image.asset('assets/images/empty-orders.png', width: 150),
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text('No Products on Wish List',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                          'Discover our New products to find a product\nworth enough to make it to your wishlist',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Commons.greyAccent2))),
                  Spacer(flex: 2)
                ],
              )),
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
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                                child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20))
                          ])
                        ])),
              ))
      ],
    );
  }

  Widget topBar() {
    return Stack(children: [
      Container(
        height: 160,
        width: MediaQuery.of(context).size.width
      ),
      Positioned(right: -10, top: -10, child: Image.asset('assets/images/beef-plate.png', width: 170)),
      Positioned(
          top: 40,
          left: 15,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Wish', style: TextStyle(fontSize: 55, color: Commons.bgColor, fontWeight: FontWeight.bold)),
            Text('List',
                style: TextStyle(fontSize: 55, color: Commons.colorFromHex('#565E54'), fontWeight: FontWeight.bold))
          ]))
    ]);
  }
}
