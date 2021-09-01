import 'package:alhaji_user_app/models/combo.dart';
import 'package:alhaji_user_app/models/orders.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatefulWidget {
  final OrdersData item;

  const OrderDetailsPage({Key key, this.item}) : super(key: key);
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 45),
          Stack(alignment: Alignment.center, children: [
            Container(width: MediaQuery.of(context).size.width, height: 50),
            Positioned(left: 20, child: Commons.backButton(context)),
            Text('Order#${widget.item?.orderCode ?? ''}'),
          ]),
          Expanded(
              child: ListView(
            children: [
              for (int index = 0; index < widget.item.items.length; index++)
                productCard(widget.item.items[index], index),
              textCard(name: 'Subtotal', value: (widget.item.itemTotal).toString()),
              textCard(name: 'Tax and Fees', value: (widget.item.totalAmount - widget.item.itemTotal).toString()),
              textCard(name: 'Grand Total', value: widget.item.totalAmount.toString()),
            ],
          )),
        ],
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

  Widget productCard(Items product, int index) {
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 25),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Image.asset('assets/images/non-veg-icon.png', width: 15),
        ),
        SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product.productDetails.name,
              style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          Text(product.productDetails.weight.toString() + 'gm',
              style: TextStyle(color: Commons.greyAccent3, fontSize: 12, fontWeight: FontWeight.w600)),
          SizedBox(height: 7),
          Row(children: [
            Text('£', style: TextStyle(color: Commons.bgColor, fontSize: 18, fontWeight: FontWeight.w600)),
            Text(product.productDetails.price.toString(),
                style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600))
          ]),
          SizedBox(height: 10)
        ]),
        Spacer(),
        Row(children: [
          Text(product.productDetails.totalQuantity?.toString() ?? '',
              style: TextStyle(color: Commons.bgColor, fontSize: 18, fontWeight: FontWeight.w600)),
          if (product.productDetails.totalQuantity != null)
            Text(' X ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          Text('£', style: TextStyle(color: Commons.bgColor, fontSize: 18, fontWeight: FontWeight.w600)),
          Text(product.productDetails.price.toString(),
              style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600))
        ]),
        SizedBox(width: 30)
      ]),
      if (product.cookingInstructions != null)
        Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(7),
            margin: EdgeInsets.symmetric(horizontal: 30),
            alignment: Alignment.center,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(color: Commons.greyAccent3)),
            child: Text(product.cookingInstructions,
                style: TextStyle(color: Commons.greyAccent3, fontSize: 14, fontWeight: FontWeight.w600))),
      SizedBox(height: 10),
    ]);
  }

  Widget comboCard(Combo combo) {
    num price = 0;
    for (int i = 0; i < combo.items.length; i++) {
      price += combo.items[i].price;
    }
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
            Text(price.toString(),
                style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600))
          ]),
          SizedBox(height: 10)
        ]),
        Spacer(),
        // Padding(
        //     padding: const EdgeInsets.only(bottom: 15),
        //     child: CartButton(
        //         cartValue: cartProvider.isProductFound(combo.name ?? '', PRODUCTTYPE.COMBO)
        //             ? cartProvider
        //             .cartProducts[cartProvider.getProductIndex(combo.name ?? '', PRODUCTTYPE.COMBO)].quantity
        //             : 0,
        //         onCartAdded: (value) {
        //           cartProvider.updateCartItem(combo: combo, count: value, price: price);
        //         },
        //         onCartRemoved: (value) {
        //           cartProvider.updateCartItem(combo: combo, count: value, price: price);
        //         })),
        SizedBox(width: 30)
      ]),
      InkWell(
          onTap: () {
            // cookingInstructionField(context);
          },
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(7),
              margin: EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), border: Border.all(color: Commons.greyAccent3)),
              child: Text('Add Cooking Instructions',
                  style: TextStyle(color: Commons.greyAccent3, fontSize: 14, fontWeight: FontWeight.w600)))),
      SizedBox(height: 10),
      Divider(thickness: 2, indent: 20, endIndent: 20)
    ]);
  }
}
