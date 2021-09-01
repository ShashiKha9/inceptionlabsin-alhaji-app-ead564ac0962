import 'package:alhaji_user_app/models/cart.dart';
import 'package:alhaji_user_app/models/products.dart';
import 'package:alhaji_user_app/provider/cart.dart';
import 'package:alhaji_user_app/provider/menu.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/utils/cart-button.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:alhaji_user_app/views/details/product-details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key key, @required this.product}) : super(key: key);
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  CartProvider cartProvider;
  MenuProvider menuProvider;
  SessionProvider sessionProvider;
  @override
  Widget build(BuildContext context) {
    menuProvider = Provider.of<MenuProvider>(context);
    sessionProvider = Provider.of<SessionProvider>(context);
    cartProvider = Provider.of<CartProvider>(context);
    Product product = widget.product;
    bool isAvailable = product.isActive && product.totalQuantity != null && product.totalQuantity != 0;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)));
          },
          child: Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(product?.images[0] ??
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcb8B75ZKqjEhyFef9sVrLDTfOPP7a-Nzy1Q&usqp=CAU'),
                                fit: BoxFit.cover,
                                colorFilter: isAvailable
                                    ? null
                                    : ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                              ))),
                      SizedBox(width: 10),
                      Container(
                          width: MediaQuery.of(context).size.width - 200,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(product?.name ?? '',
                                style: TextStyle(
                                  color: Commons.textColor.withOpacity(.9),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                )),
                            SizedBox(height: 8),
                            Text('£ ${product?.price ?? ''}',
                                style: TextStyle(
                                  color: Commons.bgColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ))
                          ])),
                    ],
                  ),
                  Column(
                    children: [
                      if (isAvailable)
                        CartButton(
                          cartValue: cartProvider.isProductFound(product.productCode, PRODUCTTYPE.PRODUCT)
                              ? cartProvider
                                  .cartProducts[cartProvider.getProductIndex(product.productCode, PRODUCTTYPE.PRODUCT)]
                                  .quantity
                              : 0,
                          onCartAdded: (value) {
                            cartProvider.updateCartItem(product.isTaxInclusive,
                                product: product, count: value, price: product.price);
                          },
                          onCartRemoved: (value) {
                            cartProvider.updateCartItem(product.isTaxInclusive,
                                product: product, count: value, price: product.price);
                          },
                          maxValue: product.totalQuantity,
                        ),
                      if (!isAvailable) SizedBox(height: 4),
                      if (!isAvailable)
                        Container(
                          child: Text('Unavailable',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              )),
                        ),
                      SizedBox(height: 8),
                      if (product.branches[0].addOns != null)
                        if (product.branches[0].addOns.isNotEmpty)
                          Text(
                            'Customizable',
                            style: TextStyle(color: Commons.greyAccent2, fontSize: 11),
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
                      product.weight.toString() + 'g ',
                      style: TextStyle(color: Commons.greyAccent4, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    Text(
                      'of ${product.name} & Pot of spice',
                      style: TextStyle(color: Commons.greyAccent4, fontSize: 11),
                    ),
                  ],
                )),
            Divider()
          ]),
        ));
  }
}
