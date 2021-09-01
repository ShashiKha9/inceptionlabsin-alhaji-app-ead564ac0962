import 'package:alhaji_user_app/models/cart.dart';
import 'package:alhaji_user_app/models/combo.dart';
import 'package:alhaji_user_app/models/products.dart';
import 'package:alhaji_user_app/provider/cart.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/utils/cart-button.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartProvider cartProvider;
  SessionProvider sessionProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartProvider = Provider.of<CartProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) => cartProvider.clearPromoCode());
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);
    sessionProvider = Provider.of<SessionProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: cartProvider.cartProducts.isEmpty
            ? Column(
                children: [
                  topBar(),
                  Spacer(),
                  Image.asset('assets/images/empty-orders.png', width: 150),
                  SizedBox(height: 10),
                  Text('Your cart is empty!', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Order some food to your cart', style: TextStyle(color: Commons.greyAccent3, fontSize: 14)),
                  SizedBox(height: 120),
                  Spacer(),
                ],
              )
            : Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  SingleChildScrollView(
                      child: Column(
                    children: [
                      topBar(),
                      SizedBox(
                        height: 20,
                      ),
                      if (cartProvider.cartProducts.isNotEmpty)
                        for (int index = 0; index < cartProvider.cartProducts.length; index++)
                          if (cartProvider.cartProducts[index].productType == PRODUCTTYPE.PRODUCT)
                            productCard(cartProvider.cartProducts[index].product, index)
                          else
                            comboCard(cartProvider.cartProducts[index].combo),
                      if (cartProvider.selectedPromoCode == null)
                        InkWell(
                            onTap: () async {
                              print(sessionProvider.bearer);
                              cartProvider.getPromoCodes(
                                  sessionProvider.bearer, sessionProvider.currentUser.customerCode);
                              promoCodeField(context, '');
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 65,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(.11),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: Offset(4.0, 4.0))
                                    ]),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text('Promo Code 🎊',
                                          style: TextStyle(color: Commons.greyAccent2, fontSize: 16)),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    alignment: Alignment.center,
                                    decoration:
                                        BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(100)),
                                    child: Text(
                                      'APPLY',
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ]))),
                      if (cartProvider.selectedPromoCode != null)
                        Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.11),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: Offset(4.0, 4.0))
                                ]),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(5),
                                child: Text('🎊', style: TextStyle(color: Commons.greyAccent2, fontSize: 20)),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 212,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: cartProvider.selectedPromoCode?.code ?? '',
                                          style: TextStyle(
                                              color: Commons.bgColor, fontSize: 16, fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: ' - ${cartProvider.selectedPromoCode.promoCodeDetails.percentage}% ',
                                          style: TextStyle(
                                              color: Commons.bgColor, fontSize: 20, fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: 'Off',
                                          style: TextStyle(
                                              color: Commons.bgColor, fontSize: 14, fontWeight: FontWeight.w600))
                                    ]),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    child: Text(
                                      cartProvider.selectedPromoCode.promoCodeDetails.remarks ?? '',
                                      style: TextStyle(
                                          color: Commons.textColor, fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ]),
                              ),
                              InkWell(
                                onTap: () {
                                  cartProvider.changePromoCode(null);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            ])),
                      textCard(
                          name: 'Subtotal', value: (cartProvider.totalCartAmount - cartProvider.taxAndFees).toString()),
                      if (cartProvider.selectedPromoCode != null)
                        textCard(
                            name: 'Discount',
                            value: ((cartProvider.totalCartAmount / 100) *
                                    cartProvider.selectedPromoCode.promoCodeDetails.percentage)
                                .toString()),
                      if (cartProvider.totalCartAmount != null)
                        textCard(name: 'Tax and Fees', value: cartProvider.taxAndFees.toString()),
                      textCard(name: 'Grand Total', value: cartProvider.totalCartAmount.toString()),
                      SizedBox(height: 100),
                    ],
                  )),
                  Positioned(
                    bottom: 20,
                    right: 25,
                    left: 25,
                    child: InkWell(
                      onTap: () {
                        // Navigator.pop(context);
                        Navigator.pushNamed(context, '/payment');
                      },
                      child: Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 50,
                          decoration: BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            'CHECKOUT',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          )),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget textCard({String name, String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(color: Commons.textColor, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(children: [
            Text(
              '£$value',
              style: TextStyle(color: Commons.textColor, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(' GBP', style: TextStyle(color: Commons.greyAccent3, fontSize: 14))
          ])
        ],
      ),
    );
  }

  Widget productCard(Product product, int index) {
    return Column(children: [
      Row(children: [
        SizedBox(width: 25),
        Image.asset('assets/images/non-veg-icon.png', width: 15),
        SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: MediaQuery.of(context).size.width - 180,
              child: Text(product.name,
                  style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600))),
          SizedBox(height: 10),
          Text(product.weight.toString() + 'gm',
              style: TextStyle(color: Commons.greyAccent3, fontSize: 12, fontWeight: FontWeight.w600)),
          SizedBox(height: 7),
          Row(children: [
            Text('£', style: TextStyle(color: Commons.bgColor, fontSize: 18, fontWeight: FontWeight.w600)),
            Text(product.price.toString(),
                style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600))
          ]),
          SizedBox(height: 10)
        ]),
        Spacer(),
        Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: CartButton(
                cartValue: cartProvider.isProductFound(product.productCode, PRODUCTTYPE.PRODUCT)
                    ? cartProvider.cartProducts[index].quantity
                    : 0,
                onCartAdded: (value) {
                  cartProvider.updateCartItem(product.isTaxInclusive,
                      product: product, count: value, price: product.price);
                },
                maxValue: product.totalQuantity,
                onCartRemoved: (value) {
                  cartProvider.updateCartItem(product.isTaxInclusive,
                      product: product, count: value, price: product.price);
                })),
        SizedBox(width: 30)
      ]),
      InkWell(
          onTap: () {
            cookingInstructionField(context, cartProvider.cartProducts[index].cookingInstruction, index);
          },
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(7),
              margin: EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), border: Border.all(color: Commons.greyAccent3)),
              child: Text(
                  cartProvider.cartProducts[index].cookingInstruction != null &&
                          cartProvider.cartProducts[index].cookingInstruction != ''
                      ? 'Edit Cooking Instructions'
                      : 'Add Cooking Instructions',
                  style: TextStyle(color: Commons.greyAccent3, fontSize: 14, fontWeight: FontWeight.w600)))),
      SizedBox(height: 10),
      if (product.branches[0].addOns.isNotEmpty)
        for (int i = 0; i < product.branches[0].addOns.length; i++)
          addOnsCard(product.branches[0].addOns[i], product.productCode, PRODUCTTYPE.PRODUCT),
      if (index != cartProvider.cartProducts.length - 1) Divider(thickness: 2, indent: 20, endIndent: 20),
    ]);
  }

  Widget comboCard(Combo combo) {
    return Column(children: [
      Row(children: [
        SizedBox(width: 25),
        Image.asset('assets/images/non-veg-icon.png', width: 15),
        SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(combo.name, style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          Text(combo.productCodes.length.toString() + 'Items',
              style: TextStyle(color: Commons.greyAccent3, fontSize: 12, fontWeight: FontWeight.w600)),
          SizedBox(height: 7),
          Row(children: [
            Text('£', style: TextStyle(color: Commons.bgColor, fontSize: 18, fontWeight: FontWeight.w600)),
            Text(combo.price.toString(),
                style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600))
          ]),
          SizedBox(height: 10)
        ]),
        Spacer(),
        Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: CartButton(
                maxValue: combo.items[0].totalQuantity,
                cartValue: cartProvider.isProductFound(combo.comboCode, PRODUCTTYPE.COMBO)
                    ? cartProvider
                        .cartProducts[cartProvider.getProductIndex(combo.comboCode, PRODUCTTYPE.COMBO)].quantity
                    : 0,
                onCartAdded: (value) {
                  cartProvider.updateCartItem(combo.isTaxInclusive, combo: combo, count: value, price: combo.price);
                },
                onCartRemoved: (value) {
                  cartProvider.updateCartItem(combo.isTaxInclusive, combo: combo, count: value, price: combo.price);
                })),
        SizedBox(width: 30)
      ]),
      SizedBox(height: 10),
      if (cartProvider.cartProducts[cartProvider.getProductIndex(combo.comboCode, PRODUCTTYPE.COMBO)].addOns != null)
        if (cartProvider
            .cartProducts[cartProvider.getProductIndex(combo.comboCode, PRODUCTTYPE.COMBO)].addOns.isNotEmpty)
          for (int i = 0;
              i <
                  cartProvider
                      .cartProducts[cartProvider.getProductIndex(combo.comboCode, PRODUCTTYPE.COMBO)].addOns.length;
              i++)
            addOnsCard(
                cartProvider
                    .cartProducts[cartProvider.getProductIndex(combo.comboCode, PRODUCTTYPE.COMBO)].addOns[i].addOn,
                combo.comboCode,
                PRODUCTTYPE.COMBO),
      Divider(thickness: 2, indent: 20, endIndent: 20)
    ]);
  }

  Widget addOnsCard(Product addOn, String productId, PRODUCTTYPE producttype) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(children: [
          Row(children: [
            // Container(
            //     width: 30,
            //     height: 30,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50),
            //         image: DecorationImage(image: NetworkImage(addOn.images[0]), fit: BoxFit.cover))),
            Text('  ' + addOn.name,
                style: TextStyle(color: Commons.textColor, fontSize: 14, fontWeight: FontWeight.w600)),
            Spacer(),
            CartButton(
                cartValue: cartProvider.isAddOnFound(productId, addOn, producttype)
                    ? cartProvider.cartProducts[cartProvider.getProductIndex(productId, producttype)]
                        .addOns[cartProvider.getAddOnIndex(productId, addOn, producttype)].count
                    : 0,
                maxValue: addOn.totalQuantity,
                onCartAdded: (value) {
                  cartProvider.updateAddOns(productId, addOn, value, producttype);
                },
                onCartRemoved: (value) {
                  cartProvider.updateAddOns(productId, addOn, value, producttype);
                })
          ]),
          SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Text(' £', style: TextStyle(color: Commons.bgColor, fontSize: 17, fontWeight: FontWeight.w600)),
                Text(addOn.price.toString(),
                    style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            Spacer(),
            Text('Suggested Add-on',
                style: TextStyle(color: Commons.greyAccent2, fontSize: 12, fontWeight: FontWeight.w600))
          ]),
          SizedBox(height: 10)
        ]));
  }

  Widget topBar() {
    return Stack(alignment: Alignment.center, children: [
      Container(width: MediaQuery.of(context).size.width, height: 60),
      Positioned(
          left: 20,
          top: 5,
          child: InkWell(
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
                        color: Colors.grey.withOpacity(.11), blurRadius: 10, spreadRadius: 2, offset: Offset(4.0, 4.0))
                  ]),
                  child: Icon(Icons.arrow_back_ios_rounded, size: 20, color: Colors.black)))),
      Text('Checkout Order', style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600))
    ]);
  }

  cookingInstructionField(BuildContext context, String initial, int index) {
    TextEditingController controller = TextEditingController();
    controller.text = initial ?? '';
    AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.all(0),
        actionsPadding: EdgeInsets.all(0),
        buttonPadding: EdgeInsets.all(0),
        insetPadding: EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        content: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              Spacer(),
              InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.cancel_sharp, size: 50, color: Commons.greyAccent2)),
              SizedBox(height: 10),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(25.0), topRight: const Radius.circular(25.0))),
                  child: Column(children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Commons.greyAccent1, borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                            controller: controller,
                            maxLines: 20,
                            minLines: 10,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Add Your cooking instruction here...',
                                hintStyle: TextStyle(color: Colors.black, fontSize: 14)))),
                    SizedBox(height: 20),
                    InkWell(
                        onTap: () {
                          cartProvider.changeCookingInstruction(index, controller.text);
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(20),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(100)),
                            child: Text('CONFIRM',
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))))
                  ]))
            ])));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  promoCodeField(BuildContext context, String initial) {
    TextEditingController controller = TextEditingController();
    controller.text = initial ?? '';
    Dialog alert = Dialog(
        insetPadding: EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        child: Consumer<CartProvider>(
          builder: (context, cart, child) {
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
                      height: MediaQuery.of(context).size.height / 2 - 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(25.0), topRight: const Radius.circular(25.0))),
                      child: cart.isPromoCodesLoading
                          ? Center(
                              child: Text('Loading...',
                                  style:
                                      TextStyle(color: Commons.greyAccent2, fontSize: 14, fontWeight: FontWeight.w600)))
                          : Column(children: [
                              if (cart.promoCodes == null)
                                Expanded(
                                  child: Center(child: Text('No Promo Codes Found')),
                                ),
                              if (cart.promoCodes != null)
                                if (cart.promoCodes.promoCodes != null)
                                  if (cart.promoCodes.promoCodes.isEmpty)
                                    Expanded(
                                      child: Center(child: Text('No Promo Codes Found')),
                                    )
                                  else
                                    Expanded(
                                        child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        for (int index = 0; index < cart.promoCodes.promoCodes.length; index++)
                                          InkWell(
                                            onTap: () {
                                              cart.changePromoCode(cart.promoCodes.promoCodes[index]);
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width - 100,
                                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                  child:
                                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width - 120,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            cart.promoCodes.promoCodes[index]?.code ?? '',
                                                            style: TextStyle(
                                                                color: Commons.bgColor,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                          Text(
                                                            ' - ${cart.promoCodes.promoCodes[index]?.promoCodeDetails?.percentage}% ',
                                                            style: TextStyle(
                                                                color: Commons.bgColor,
                                                                fontSize: 24,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                          Text(
                                                            'Off',
                                                            style: TextStyle(
                                                                color: Commons.bgColor,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width - 120,
                                                      child: Text(
                                                        cart.promoCodes.promoCodes[index].promoCodeDetails.remarks ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Commons.textColor,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                // if (cart.selectedPromoCode != null)
                                                //   if (cart.selectedPromoCode.sId == cart.promoCodes.promoCodes[index].sId)
                                                Text('APPLY',
                                                    style: TextStyle(
                                                        color: Commons.bgColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600)),
                                                // Icon(Icons.check, color: Commons.bgColor)
                                              ],
                                            ),
                                          )
                                      ],
                                    )),
                              InkWell(
                                  onTap: () {},
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 65,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(100),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.withOpacity(.11),
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                                offset: Offset(4.0, 4.0))
                                          ]),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        SizedBox(width: 10),
                                        Container(
                                          width: MediaQuery.of(context).size.width - 205,
                                          child: TextFormField(
                                              controller: controller,
                                              maxLines: 20,
                                              minLines: 10,
                                              style: TextStyle(color: Colors.black, fontSize: 16),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Enter Promo code',
                                                  hintStyle: TextStyle(color: Commons.greyAccent2, fontSize: 14))),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Commons.bgColor, borderRadius: BorderRadius.circular(100)),
                                          child: Text(
                                            'CHECK',
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ]))),
                            ])),
                ]));
          },
        ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return alert;
        });
      },
    );
  }
}
