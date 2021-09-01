import 'package:flutter/material.dart';

import 'commons.dart';

class CartButton extends StatelessWidget {
  final int cartValue;
  final int maxValue;
  final int minValue;
  final void Function(int) onCartAdded;
  final void Function(int) onCartRemoved;
  final Color color;
  CartButton(
      {Key key,
      this.cartValue = 0,
      @required this.onCartAdded,
      @required this.onCartRemoved,
      this.maxValue = 0,
      this.minValue = 0,
      this.color = Colors.white})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (cartValue == 0) {
      return InkWell(
        onTap: () {
          if (cartValue < maxValue) onCartAdded(cartValue + 1);
        },
        child: Container(
          width: 100,
          padding: EdgeInsets.symmetric(vertical: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(100), border: Border.all(color: Commons.bgColor)),
          child: Text(
            'ADD',
            style: TextStyle(color: Commons.bgColor, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Container(
        width: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                if (cartValue > minValue) onCartRemoved(cartValue - 1);
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Commons.bgColor)),
                child: Image.asset(
                  'assets/images/minus.png',
                  width: 12,
                ),
              ),
            ),
            Text(
              cartValue.toString(),
              style: TextStyle(color: Commons.greyAccent4, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            InkWell(
              onTap: () {
                if (cartValue < maxValue) onCartAdded(cartValue + 1);
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(14)),
                child: Image.asset(
                  'assets/images/plus.png',
                  width: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
