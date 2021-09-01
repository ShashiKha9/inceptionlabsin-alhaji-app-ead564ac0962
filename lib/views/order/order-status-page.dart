import 'dart:ui';

import 'package:alhaji_user_app/models/orders.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:flutter/material.dart';

class OrderStatusPage extends StatefulWidget {
  final OrdersData item;

  const OrderStatusPage({Key key, @required this.item}) : super(key: key);
  @override
  _OrderStatusPageState createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  String parseTime(String dateTime) {
    String time = '';
    if (dateTime != null && dateTime != '') {
      DateTime _dt = DateTime.parse(dateTime);
      time = '${_dt.hour < 12 ? {_dt.hour} : _dt.hour - 12}' +
          ':${_dt.minute > 10 ? _dt.minute : "0${_dt.minute}"} ' +
          '${_dt.hour < 12 ? 'AM' : 'PM'}';
    }
    return time;
  }

  String getUpdatedTime(String data) {
    String dateTime;
    if (widget.item.statusList != null) {
      for (int i = 0; i < widget.item.statusList.length; i++) {
        print([widget.item.statusList[i].status, i]);
        if (widget.item.statusList[i].status == data) {
          dateTime = widget.item.statusList[i].createdDate;
          break;
        }
      }
    }
    return parseTime(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.item.status == 'READY_FOR_DELIVERY' ? Commons.bgColor : Commons.yellowColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  widget.item.status == 'READY_FOR_DELIVERY'
                      ? 'assets/images/order-completed.png'
                      : 'assets/images/saltbay.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2 + 80,
                  fit: BoxFit.cover,
                ),
                Positioned(top: 45, left: 15, child: Commons.backButton(context)),
                Positioned(
                    bottom: -5,
                    left: 0,
                    right: 0,
                    child: Container(
                        height: 120,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: widget.item.status == 'READY_FOR_DELIVERY' ? Commons.bgColor : Commons.yellowColor,
                            borderRadius:
                            BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50))),
                        child: Row(children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 3) * 2 - 41,
                            padding: EdgeInsets.only(left: 20, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Order Status',
                                    style: TextStyle(
                                        color:
                                        widget.item.status == 'READY_FOR_DELIVERY' ? Colors.white : Colors.black)),
                                SizedBox(height: 10),
                                Text(
                                    widget.item.status == 'PENDING'
                                        ? 'Order Pending'
                                        : widget.item.status == 'READY_FOR_DELIVERY'
                                        ? 'Ready to Collect'
                                        : widget.item.status == 'PROCESSING'
                                        ? 'Preparing'
                                        : 'Order Confirmed',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: widget.item.status == 'READY_FOR_DELIVERY' ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          VerticalDivider(
                            width: 0,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          Container(
                              width: (MediaQuery.of(context).size.width / 3),
                              padding: EdgeInsets.only(right: 20, left: 10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Delivery Place',
                                        style: TextStyle(
                                            color: widget.item.status == 'READY_FOR_DELIVERY'
                                                ? Colors.white
                                                : Colors.black)),
                                    SizedBox(height: 10),
                                    Text(widget.item.branch.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: widget.item.status == 'READY_FOR_DELIVERY'
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ]))
                        ]))),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2 - 80,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50))),
              child: Column(
                children: [
                  statusWidget(
                      needIcon: widget.item.status == "CREATED",
                      title: 'Order Confirmed',
                      time: getUpdatedTime('CREATED')),
                  SizedBox(height: 12),
                  statusWidget(
                      needIcon: widget.item.status == 'PROCESSING' || widget.item.status == 'READY_FOR_DELIVERY',
                      title: 'Preparing Food',
                      time: getUpdatedTime('PROCESSING')),
                  SizedBox(height: 12),
                  statusWidget(
                      needIcon: widget.item.status == 'READY_FOR_DELIVERY',
                      title: 'Ready to Collect',
                      time: getUpdatedTime('READY_FOR_DELIVERY')),
                  Spacer(),
                  Divider(
                    height: 5,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Shop Incharge', style: TextStyle(color: Colors.black)),
                          SizedBox(height: 6),
                          Text(
                            widget.item.branch.name,
                            style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(100)),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/call.png',
                              width: 30,
                            ),
                            Text(
                              ' CALL ',
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget statusWidget({bool needIcon = true, @required String title, @required String time}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        needIcon
            ? Image.asset(
          'assets/images/circle.png',
          width: 20,
        )
            : Container(
          width: 20,
          height: 20,
          decoration:
          BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(100)),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 200,
          child: Text(title, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        Container(
          width: 70,
          alignment: Alignment.centerRight,
          child: Text(time,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              )),
        ),
      ],
    );
  }
}
