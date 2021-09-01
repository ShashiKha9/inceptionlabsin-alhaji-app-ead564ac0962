import 'package:alhaji_user_app/models/cart.dart';
import 'package:alhaji_user_app/models/combo.dart';
import 'package:alhaji_user_app/provider/cart.dart';
import 'package:alhaji_user_app/provider/menu.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/utils/cart-button.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:alhaji_user_app/views/details/combo-details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComboCard extends StatefulWidget {
  final Combo combo;
  const ComboCard({Key key, @required this.combo}) : super(key: key);

  @override
  _ComboCardState createState() => _ComboCardState();
}

class _ComboCardState extends State<ComboCard> {
  CartProvider cartProvider;
  MenuProvider menuProvider;
  SessionProvider sessionProvider;
  @override
  Widget build(BuildContext context) {
    Combo combo = widget.combo;
    menuProvider = Provider.of<MenuProvider>(context);
    sessionProvider = Provider.of<SessionProvider>(context);
    cartProvider = Provider.of<CartProvider>(context);
    bool isAvailable = combo.isActive &&
        combo.items[0].totalQuantity != null &&
        combo.items[0].totalQuantity != 0 &&
        combo.isAvailable &&
        combo.price != 0;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ComboDetailsScreen(combo: combo)));
          },
          child: Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: NetworkImage(combo.images.isNotEmpty
                                  ? combo.images[0]
                                  : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcb8B75ZKqjEhyFef9sVrLDTfOPP7a-Nzy1Q&usqp=CAU'),
                              fit: BoxFit.cover))),
                  Container(
                      width: MediaQuery.of(context).size.width - 200,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(combo?.name ?? '',
                            style: TextStyle(
                              color: Commons.textColor.withOpacity(.9),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            )),
                        SizedBox(height: 8),
                        Text('£' + combo.price.toString(),
                            style: TextStyle(color: Commons.bgColor, fontWeight: FontWeight.bold, fontSize: 13))
                      ])),
                  Column(
                    children: [
                      if (isAvailable)
                        CartButton(
                          cartValue: cartProvider.isProductFound(combo.comboCode ?? '', PRODUCTTYPE.COMBO)
                              ? cartProvider
                                  .cartProducts[cartProvider.getProductIndex(combo.comboCode ?? '', PRODUCTTYPE.COMBO)]
                                  .quantity
                              : 0,
                          onCartAdded: (value) {
                            print(value);
                            if (value == 1) {
                              showAddOns(context, combo.comboCode, combo);
                            }
                            cartProvider.updateCartItem(combo.isTaxInclusive,
                                combo: combo, count: value, price: combo.price);
                          },
                          onCartRemoved: (value) {
                            cartProvider.updateCartItem(combo.isTaxInclusive,
                                combo: combo, count: value, price: combo.price);
                          },
                          maxValue: isAvailable ? combo.items[0].totalQuantity : 0,
                        ),
                      SizedBox(height: 8),
                      if (!isAvailable) SizedBox(height: 4),
                      if (!isAvailable)
                        Container(
                            child: Text('Unavailable',
                                textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 12))),
                      if (isAvailable)
                        GestureDetector(
                          onTap: () {
                            showAddOns(context, combo.comboCode, combo);
                          },
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: Text('Customize',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Commons.greyAccent3, fontSize: 12))),
                        ),
                    ],
                  )
                ]),
            SizedBox(height: 4),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      combo.shortDescription,
                      style: TextStyle(color: Commons.greyAccent4, fontSize: 11),
                    ),
                  ],
                )),
            Divider()
          ]),
        ));
  }

  showAddOns(BuildContext context, String productCode, Combo combo) {
    Dialog alert = Dialog(
        insetPadding: EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        child: Consumer<CartProvider>(builder: (context, cart, child) {
          return Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Column(children: [
                Spacer(),
                InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.cancel_sharp, size: 50, color: Commons.greyAccent2)),
                SizedBox(height: 10),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(25.0), topRight: const Radius.circular(25.0))),
                    child: comboAddonWidget(productCode, combo)),
              ]));
        }));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return alert;
        });
      },
    );
  }

  Widget comboAddonWidget(String productCode, Combo combo) {
    int quantity = 0;
    if (cartProvider.isProductFound(productCode, PRODUCTTYPE.COMBO)) {
      quantity = cartProvider.cartProducts[cartProvider.getProductIndex(productCode, PRODUCTTYPE.COMBO)].quantity;
    }
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,
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
                                              image:
                                                  NetworkImage(menuProvider.productList.productsList[index].images[0]),
                                              fit: BoxFit.cover)),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      width: MediaQuery.of(context).size.width - 250,
                                      child: Text(menuProvider.productList.productsList[index].name,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
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
                                        cartValue: cartProvider.isAddOnFound(productCode,
                                                menuProvider.productList.productsList[index], PRODUCTTYPE.COMBO)
                                            ? (cartProvider
                                                    .cartProducts[
                                                        cartProvider.getProductIndex(productCode, PRODUCTTYPE.COMBO)]
                                                    .addOns[cartProvider.getAddOnIndex(
                                                        productCode,
                                                        menuProvider.productList.productsList[index],
                                                        PRODUCTTYPE.COMBO)]
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
                  ),
            if (cartProvider.cartProducts.isNotEmpty) SizedBox(height: 80)
          ],
        ),
        if (cartProvider.cartProducts.isNotEmpty) Positioned(bottom: 10, child: cartDetailsCard())
      ],
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
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                        size: 20,
                      ))
                ])
              ])),
    );
  }
}
