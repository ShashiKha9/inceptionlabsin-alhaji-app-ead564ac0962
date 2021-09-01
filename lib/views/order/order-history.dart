import 'package:alhaji_user_app/models/orders.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:alhaji_user_app/views/details/order-details.dart';
import 'package:flutter/material.dart';

class OrdersHistoryPage extends StatefulWidget {
  final List<OrdersData> orders;

  const OrdersHistoryPage({Key key, this.orders}) : super(key: key);

  @override
  _OrdersHistoryPageState createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<OrdersHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return widget.orders.isNotEmpty ? ordersPage() : emptyPage();
  }

  Widget ordersPage() {
    return Expanded(
      child: ListView(
        children: [for (int index = widget.orders.length - 1; index >= 0; index--) orderItem(widget.orders[index])],
      ),
    );
  }

  Widget orderItem(OrdersData item) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => OrderDetailsPage(item: item)));
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [
            BoxShadow(color: Colors.blueGrey.withOpacity(.1), blurRadius: 2, spreadRadius: 2, offset: Offset(2, 1)),
          ]),
          child: Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(item.items[0].productDetails.images[0]), fit: BoxFit.cover))),
                  Container(
                      width: MediaQuery.of(context).size.width - 125,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Text('Order No: ', style: TextStyle(color: Commons.bgColor, fontSize: 16)),
                              Text(item.orderCode, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        ),
                        Text('${parseDate(item.createdDate)} - ${item.items.length} items',
                            style: TextStyle(color: Commons.greyAccent3, fontSize: 14)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('Ordered Delivery - ${item.orderType.toLowerCase()}',
                              style: TextStyle(color: Commons.greyAccent3, fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ])),
                ]),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(100)),
              child: Text('Order Delivered',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ])),
    );
  }

  String parseDate(String date) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    DateTime _dt = DateTime.parse(date);

    String time = '${_dt.hour < 12 ? {_dt.hour} : _dt.hour - 12}' +
        ':${_dt.minute > 10 ? _dt.minute : "0${_dt.minute}"} ' +
        '${_dt.hour < 12 ? 'AM' : 'PM'}';

    return '${_dt.day} ${months[_dt.month - 1]}, $time';
  }

  Widget emptyPage() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty-orders.png', width: MediaQuery.of(context).size.width / 3),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'No Orders Completed',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'No Orders have been Completed yet.\nDiscover and Order now',
              textAlign: TextAlign.center,
              style: TextStyle(color: Commons.greyAccent2),
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
