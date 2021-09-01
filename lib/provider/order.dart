import 'package:alhaji_user_app/models/orders.dart';
import 'package:alhaji_user_app/utils/dio-request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  List<OrdersData> _upComingOrders = [];
  List<OrdersData> _historyOrders = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<OrdersData> get upComingOrder => _upComingOrders;
  List<OrdersData> get historyOrder => _historyOrders;
  getOrders(String bearer, String customerCode) async {
    if (!_isLoading) {
      _isLoading = true;
      _upComingOrders = [];
      _historyOrders = [];
      notifyListeners();
      try {
        List sample = [];

        List<OrdersData> _orders = [];
        dioRequest.options.headers.addAll({'Authorization': 'Bearer $bearer'});
        var response = await dioRequest.get('orders?customerCode=$customerCode');
        print(response);
        if (response.data.runtimeType != sample.runtimeType) {
          _orders = Orders.fromJson(response.data).result;
          for (int i = 0; i < _orders.length; i++) {
            if (_orders[i].status == 'DELIVERED') {
              _historyOrders.add(_orders[i]);
            } else if (_orders[i].status != null && _orders[i].status != '') {
              _upComingOrders.add(_orders[i]);
            }
          }
        }
        _isLoading = false;
        notifyListeners();
      } on DioError catch (e) {
        print(e.response);
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
