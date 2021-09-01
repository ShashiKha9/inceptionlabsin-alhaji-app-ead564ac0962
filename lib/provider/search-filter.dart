import 'package:alhaji_user_app/models/cart.dart';
import 'package:alhaji_user_app/models/products.dart';
import 'package:alhaji_user_app/utils/dio-request.dart';
import 'package:flutter/material.dart';

enum SORTBY { RATING, PRICE, QUNANTITY }

class SearchFilterProvider with ChangeNotifier {
  PRODUCTTYPE _menu = PRODUCTTYPE.PRODUCT;
  PRODUCTTYPE get menu => _menu;

  SORTBY _sortBy;
  SORTBY get sortBy => _sortBy;

  int _rating;
  int get rating => _rating;

  List<Product> _productList = [];
  List<Product> get productList => _productList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RangeValues _rangeValues = RangeValues(0, 500);

  RangeValues get rangeValues => _rangeValues;

  changeProductType(PRODUCTTYPE producttype) {
    _menu = producttype;
    notifyListeners();
  }

  changeSortBy(SORTBY sortby) {
    if (_sortBy == null || _sortBy != sortby) {
      _sortBy = sortby;
    } else {
      _sortBy = null;
    }
    notifyListeners();
  }

  changeRating(int rating) {
    if (_rating == null || _rating != rating) {
      _rating = rating;
    } else {
      _rating = null;
    }
    notifyListeners();
  }

  changeRange(RangeValues values) {
    _rangeValues = values;
    notifyListeners();
  }

  Future<void> applyProducts(String bearer, String branchCode) async {
    List sample = [];
    _isLoading = true;
    _productList = [];
    notifyListeners();
    try {
      ProductsList _productsList;
      dioRequest.options.headers.addAll({'Authorization': 'Bearer $bearer'});
      var response =
          await dioRequest.get('products?branchCode=$branchCode${getSortBy() != null ? '&sortBy=${getSortBy()}' : ''}');
      print(response);
      if (response.data.runtimeType != sample.runtimeType) {
        _productsList = ProductsList.fromJson(response.data);
        if (_productsList?.productsList != null) {
          for (int i = 0; i < _productsList.productsList.length; i++) {
            bool found = false;
            if (_productsList.productsList[i].price > rangeValues.start &&
                _productsList.productsList[i].price < rangeValues.end) found = true;
            if (found) {
              _productList.add(_productsList.productsList[i]);
            }
          }
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  String getSortBy() {
    String data;
    if (_sortBy == SORTBY.PRICE) data = 'price';
    if (_sortBy == SORTBY.RATING) data = 'rating';
    if (_sortBy == SORTBY.QUNANTITY) data = 'quantity';
    return data;
  }

  searchProducts(String searchText, String bearer, String branchCode) async {
    List sample = [];
    _isLoading = true;
    _productList = [];
    notifyListeners();
    try {
      ProductsList _productsList;
      dioRequest.options.headers.addAll({'Authorization': 'Bearer $bearer'});
      var response = await dioRequest.get('products?branchCode=$branchCode&searchText=$searchText');
      print(response);
      if (response.data.runtimeType != sample.runtimeType) _productsList = ProductsList.fromJson(response.data);
      if (_productsList?.productsList != null) {
        _productList = _productsList.productsList;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  clear() {
    _productList = [];
    _sortBy = null;
    _rangeValues = RangeValues(0, 500);
    _rating = null;
    _menu = PRODUCTTYPE.PRODUCT;
    notifyListeners();
  }
}
