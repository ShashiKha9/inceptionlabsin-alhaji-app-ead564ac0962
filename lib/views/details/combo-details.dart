import 'package:alhaji_user_app/models/cart.dart';
import 'package:alhaji_user_app/models/combo.dart';
import 'package:alhaji_user_app/provider/cart.dart';
import 'package:alhaji_user_app/provider/menu.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/provider/wishlist.dart';
import 'package:alhaji_user_app/utils/cart-button.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComboDetailsScreen extends StatefulWidget {
  final Combo combo;

  const ComboDetailsScreen({Key key, this.combo}) : super(key: key);
  @override
  _ComboDetailsScreenState createState() => _ComboDetailsScreenState();
}

class _ComboDetailsScreenState extends State<ComboDetailsScreen> {
  CartProvider cartProvider;
  WishListProvider wishListProvider;
  SessionProvider sessionProvider;
  MenuProvider menuProvider;
  bool isAvailable;
  @override
  void initState() {
    super.initState();
    isAvailable = widget.combo.isActive &&
        widget.combo.items[0].totalQuantity != null &&
        widget.combo.items[0].totalQuantity != 0 &&
        widget.combo.isAvailable &&
        widget.combo.price != 0;
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);
    wishListProvider = Provider.of<WishListProvider>(context);
    sessionProvider = Provider.of<SessionProvider>(context);
    menuProvider = Provider.of<MenuProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(height: MediaQuery.of(context).size.height),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Column(
                  children: [
                    topBar(),
                    SizedBox(height: 20),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(widget.combo?.name ?? '',
                            style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600))),
                    SizedBox(height: 20),
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: NetworkImage(widget.combo.images.isNotEmpty
                                      ? widget.combo.images[0]
                                      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcb8B75ZKqjEhyFef9sVrLDTfOPP7a-Nzy1Q&usqp=CAU'),
                                  fit: BoxFit.cover)),
                        ),
                        Positioned(
                          top: 15,
                          right: 15,
                          child: InkWell(
                            onTap: () async {
                              await wishListProvider.updateWishList(sessionProvider.bearer,
                                  sessionProvider.currentUser.customerCode, sessionProvider.currentBranch.branchCode,
                                  combo: widget.combo);
                            },
                            child: wishListProvider.isLoading
                                ? Container(
                                    width: 25,
                                    height: 25,
                                    padding: EdgeInsets.fromLTRB(2, 4, 2, 3),
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                    child: Image.asset("assets/images/heart.gif"))
                                : Container(
                                    width: 25,
                                    height: 25,
                                    padding: EdgeInsets.fromLTRB(5, 7, 5, 6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: wishListProvider.isProductAvailable(combo: widget.combo)
                                            ? Commons.bgColor
                                            : Colors.black38),
                                    child: Image.asset('assets/images/heart-icon.png', color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('£${widget.combo.price}',
                              style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w600)),
                          Column(
                            children: [
                              if (isAvailable) cartValueButton(widget.combo.price),
                              if (!isAvailable) SizedBox(height: 5),
                              if (!isAvailable)
                                Text('Unavailable',
                                    textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      child: Text(widget.combo?.fullDescription ?? '',
                          style: TextStyle(color: Commons.greyAccent3, fontSize: 14)),
                    ),
                    SizedBox(height: 20),
                    addOnsCard(),
                    SizedBox(height: 20),
                    if (cartProvider.cartProducts.isNotEmpty) SizedBox(height: 60),
                  ],
                ),
              ),
            ),
            if (cartProvider.cartProducts.isNotEmpty)
              Positioned(bottom: 15, right: 25, left: 25, child: cartDetailsCard())
          ],
        ),
      ),
    );
  }

  addOnsCard() {
    Combo combo = widget.combo;
    String productCode = widget.combo.comboCode;
    int quantity = 0;
    if (cartProvider.isProductFound(productCode, PRODUCTTYPE.COMBO)) {
      quantity = cartProvider.cartProducts[cartProvider.getProductIndex(productCode, PRODUCTTYPE.COMBO)].quantity;
    }
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Commons.colorFromHex('#F6F6F6'), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text('Choice of Add On', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
          Divider(thickness: 1),
          if (!menuProvider.isProductsLoading && menuProvider.productList != null)
            if (menuProvider.productList.productsList != null)
              for (int i = 0; i < menuProvider.categoriesList.result.length; i++)
                Column(
                  children: [
                    if (menuProvider.categoriesList.result[i].name.toLowerCase() != 'meals')
                      Row(
                        children: [
                          Text(menuProvider.categoriesList.result[i].name,
                              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    for (int index = 0; index < menuProvider.productList.productsList.length; index++)
                      if (menuProvider.categoriesList.result[i].categoryCode ==
                          menuProvider.productList.productsList[index].categoryCode)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        image: DecorationImage(
                                            image: NetworkImage(menuProvider.productList.productsList[index].images[0]),
                                            fit: BoxFit.cover)),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 285,
                                    child: Text(menuProvider.productList.productsList[index].name,
                                        style:
                                            TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Row(children: [
                                Text('+£' + menuProvider.productList.productsList[index].price.toString(),
                                    style: TextStyle(color: Commons.greyAccent3, fontSize: 14)),
                                SizedBox(width: 10),
                                if (cartProvider.isProductFound(productCode, PRODUCTTYPE.COMBO) &&
                                    combo.productCodes
                                        .contains(menuProvider.productList.productsList[index].productCode))
                                  CartButton(
                                      color: Commons.colorFromHex('#F6F6F6'),
                                      cartValue: cartProvider.isAddOnFound(productCode,
                                              menuProvider.productList.productsList[index], PRODUCTTYPE.COMBO)
                                          ? (cartProvider
                                                  .cartProducts[
                                                      cartProvider.getProductIndex(productCode, PRODUCTTYPE.COMBO)]
                                                  .addOns[cartProvider.getAddOnIndex(productCode,
                                                      menuProvider.productList.productsList[index], PRODUCTTYPE.COMBO)]
                                                  .count) +
                                              quantity
                                          : quantity,
                                      maxValue: menuProvider.productList.productsList[index].totalQuantity - quantity,
                                      minValue: quantity,
                                      onCartAdded: (value) {
                                        cartProvider.updateAddOns(
                                            productCode,
                                            menuProvider.productList.productsList[index],
                                            value - quantity,
                                            PRODUCTTYPE.COMBO);
                                      },
                                      onCartRemoved: (value) {
                                        cartProvider.updateAddOns(
                                            productCode,
                                            menuProvider.productList.productsList[index],
                                            value - quantity,
                                            PRODUCTTYPE.COMBO);
                                      }),
                                if (cartProvider.isProductFound(productCode, PRODUCTTYPE.COMBO) &&
                                    !combo.productCodes
                                        .contains(menuProvider.productList.productsList[index].productCode))
                                  CartButton(
                                      color: Commons.colorFromHex('#F6F6F6'),
                                      cartValue: cartProvider.isAddOnFound(productCode,
                                              menuProvider.productList.productsList[index], PRODUCTTYPE.COMBO)
                                          ? cartProvider
                                              .cartProducts[
                                                  cartProvider.getProductIndex(productCode, PRODUCTTYPE.COMBO)]
                                              .addOns[cartProvider.getAddOnIndex(productCode,
                                                  menuProvider.productList.productsList[index], PRODUCTTYPE.COMBO)]
                                              .count
                                          : 0,
                                      maxValue: menuProvider.productList.productsList[index].totalQuantity,
                                      onCartAdded: (value) {
                                        cartProvider.updateAddOns(productCode,
                                            menuProvider.productList.productsList[index], value, PRODUCTTYPE.COMBO);
                                      },
                                      onCartRemoved: (value) {
                                        cartProvider.updateAddOns(productCode,
                                            menuProvider.productList.productsList[index], value, PRODUCTTYPE.COMBO);
                                      }),
                              ]),
                            ],
                          ),
                        ),
                    SizedBox(height: 10),
                  ],
                )
        ],
      ),
    );
  }

  cartDetailsCard() {
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
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                        size: 20,
                      ))
                ])
              ])),
    );
  }

  Widget cartValueButton(num price) {
    int value = cartProvider.cartProducts.isEmpty ||
            !cartProvider.isProductFound(widget.combo.comboCode, PRODUCTTYPE.COMBO)
        ? 0
        : cartProvider.cartProducts[cartProvider.getProductIndex(widget.combo.comboCode, PRODUCTTYPE.COMBO)].quantity;
    return value == 0
        ? InkWell(
            onTap: () {
              cartProvider.updateCartItem(widget.combo.isTaxInclusive, combo: widget.combo, count: 1, price: price);
            },
            child: Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(14)),
                child: Text('ADD', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))))
        : Row(
            children: [
              InkWell(
                onTap: () {
                  cartProvider.updateCartItem(widget.combo.isTaxInclusive,
                      combo: widget.combo, count: value - 1, price: price);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14), border: Border.all(color: Commons.bgColor)),
                  child: Image.asset(
                    'assets/images/minus.png',
                    width: 15,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text('$value', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500)),
              SizedBox(width: 12),
              InkWell(
                onTap: () {
                  cartProvider.updateCartItem(widget.combo.isTaxInclusive,
                      combo: widget.combo, count: value + 1, price: price);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(14)),
                  child: Image.asset(
                    'assets/images/plus.png',
                    width: 15,
                  ),
                ),
              ),
            ],
          );
  }

  Widget detailsCard({String img, String name, String value}) {
    return Row(
      children: [
        Image.asset(
          img,
          width: 28,
        ),
        SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: TextStyle(color: Commons.textColor.withOpacity(.8), fontSize: 15, fontWeight: FontWeight.w600)),
            Text(value, style: TextStyle(color: Commons.bgColor, fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        )
      ],
    );
  }

  Widget topBar() {
    return Row(
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
                    color: Colors.grey.withOpacity(.11), blurRadius: 10, spreadRadius: 2, offset: Offset(4.0, 4.0))
              ]),
              child: Icon(Icons.arrow_back_ios_rounded, size: 20, color: Colors.black)),
        ),
        Row(
          children: [
            Icon(Icons.star, color: Commons.yellowColor, size: 20),
            Text('4.5', style: TextStyle(color: Commons.textColor, fontSize: 14, fontWeight: FontWeight.w600)),
            SizedBox(width: 6),
            Text('(30+)', style: TextStyle(color: Commons.greyAccent2, fontSize: 14)),
            SizedBox(width: 6),
            InkWell(
                onTap: () {},
                child: Text(
                  'See Review',
                  style: TextStyle(color: Commons.bgColor, decoration: TextDecoration.underline, fontSize: 13),
                )),
          ],
        )
      ],
    );
  }
}
