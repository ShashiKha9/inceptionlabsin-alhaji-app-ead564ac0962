import 'package:alhaji_user_app/models/cart.dart';
import 'package:alhaji_user_app/models/combo.dart';
import 'package:alhaji_user_app/models/products.dart';
import 'package:alhaji_user_app/provider/cart.dart';
import 'package:alhaji_user_app/provider/menu.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/provider/wishlist.dart';
import 'package:alhaji_user_app/utils/cart-button.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:alhaji_user_app/views/details/combo-details.dart';
import 'package:alhaji_user_app/views/details/product-details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrendingItemCard extends StatefulWidget {
  final Product product;
  final Combo combo;

  const TrendingItemCard({
    Key key,
    this.product,
    this.combo,
  }) : super(key: key);
  @override
  _TrendingItemCardState createState() => _TrendingItemCardState();
}

class _TrendingItemCardState extends State<TrendingItemCard> {
  MenuProvider menuProvider;
  WishListProvider wishListProvider;
  SessionProvider sessionProvider;
  String tapId;
  CartProvider cartProvider;
  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);
    menuProvider = Provider.of<MenuProvider>(context);
    wishListProvider = Provider.of<WishListProvider>(context);
    sessionProvider = Provider.of<SessionProvider>(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
            onTap: () {
              if (widget.combo != null) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ComboDetailsScreen(combo: widget.combo)));
              }
              if (widget.product != null) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: widget.product)));
              }
            },
            child: Column(children: [
              Stack(children: [
                Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: NetworkImage(widget.combo != null ? widget.combo.images[0] : widget.product.images[0]),
                          fit: BoxFit.cover)),
                ),
                Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.black12),
                ),
                if (widget.product != null)
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: CartButton(
                          cartValue: cartProvider.isProductFound(widget.product.productCode, PRODUCTTYPE.PRODUCT)
                              ? cartProvider
                                  .cartProducts[
                                      cartProvider.getProductIndex(widget.product.productCode, PRODUCTTYPE.PRODUCT)]
                                  .quantity
                              : 0,
                          onCartAdded: (value) {
                            cartProvider.updateCartItem(widget.product.isTaxInclusive,
                                product: widget.product, count: value, price: widget.product.price);
                          },
                          onCartRemoved: (value) {
                            cartProvider.updateCartItem(widget.product.isTaxInclusive,
                                product: widget.product, count: value, price: widget.product.price);
                          },
                          maxValue: widget.product.totalQuantity))
                else
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: CartButton(
                          cartValue: cartProvider.isProductFound(widget.combo.comboCode, PRODUCTTYPE.COMBO)
                              ? cartProvider
                                  .cartProducts[cartProvider.getProductIndex(widget.combo.comboCode, PRODUCTTYPE.COMBO)]
                                  .quantity
                              : 0,
                          onCartAdded: (value) {
                            cartProvider.updateCartItem(widget.combo.isTaxInclusive,
                                combo: widget.combo, count: value, price: widget.combo.price);
                          },
                          onCartRemoved: (value) {
                            cartProvider.updateCartItem(widget.combo.isTaxInclusive,
                                combo: widget.combo, count: value, price: widget.combo.price);
                          },
                          maxValue: 10)),
                Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                        width: 60,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text('4.5 ',
                              style: TextStyle(color: Commons.bgColor, fontSize: 14, fontWeight: FontWeight.w800)),
                          Icon(Icons.star, color: Colors.orange, size: 18)
                        ]))),
                Positioned(top: 8, right: 10, child: likeButton(widget.product, widget.combo))
              ]),
              Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  alignment: Alignment.centerLeft,
                  child: Text(widget.product != null ? (widget.product.name ?? '') : (widget.combo.name),
                      style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold))),
              Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  alignment: Alignment.centerLeft,
                  child: Text(
                      '£ ' +
                          (widget.product != null
                              ? (widget.product.price.toString())
                              : (widget.combo.price.toString())),
                      style: TextStyle(color: Commons.bgColor, fontSize: 16, fontWeight: FontWeight.bold))),
            ])));
  }

  Widget likeButton(Product product, Combo combo) {
    String code = product != null ? product.productCode : combo.comboCode;
    return InkWell(
        onTap: () {
          setState(() {
            tapId = code;
          });
          wishListProvider.updateWishList(sessionProvider.bearer, sessionProvider.currentUser.customerCode,
              sessionProvider.currentBranch.branchCode,
              product: product, combo: combo);
        },
        child: wishListProvider.isLoading && tapId == code
            ? Container(
                width: 25,
                height: 25,
                padding: EdgeInsets.fromLTRB(2, 4, 2, 3),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.white),
                child: Image.asset("assets/images/heart.gif"))
            : Container(
                width: 25,
                height: 25,
                padding: EdgeInsets.fromLTRB(5, 7, 5, 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: !wishListProvider.isProductAvailable(product: product, combo: combo)
                        ? Colors.black38
                        : Commons.bgColor),
                child: Image.asset('assets/images/heart-icon.png', color: Colors.white)));
  }
}
