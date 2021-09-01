import 'package:alhaji_user_app/models/catagories.dart';
import 'package:alhaji_user_app/models/combo.dart';
import 'package:alhaji_user_app/models/products.dart';
import 'package:alhaji_user_app/provider/wishlist.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '/utils/dio-request.dart';

class MenuProvider extends ChangeNotifier {
  CategoriesList _categoriesList;
  ProductsList _productList;
  CombosList _combosList;
  List<CommonProduct> _trendingOrders = [];
  bool _isCategoriesLoading = true;
  bool _isProductsLoading = false;
  bool _isTrendingOrdersLoading = false;

  //Getters
  CategoriesList get categoriesList => _categoriesList;
  ProductsList get productList => _productList;
  CombosList get combosList => _combosList;
  List<CommonProduct> get trendingOrders => _trendingOrders;
  bool get isCategoriesLoading => _isCategoriesLoading;
  bool get isProductsLoading => _isProductsLoading;
  bool get isTrendingOrdersLoading => _isTrendingOrdersLoading;

  reload(accessToken, String branchCode) {
    getCategories(accessToken);
    getProducts(accessToken, branchCode);
    getCombos(accessToken, branchCode);
    getTrendingOrders(accessToken, branchCode);
  }

  getCategories(accessToken) async {
    _isCategoriesLoading = true;
    _categoriesList = null;
    List sample = [];
    notifyListeners();
    try {
      dioRequest.options.headers.addAll({'Authorization': 'Bearer $accessToken'});
      var response = await dioRequest.get('categories');
      if (response.data.runtimeType != sample.runtimeType) _categoriesList = CategoriesList.fromJson(response.data);
      _isCategoriesLoading = false;
      notifyListeners();
    } on DioError catch (e) {
      print(e.response);
      _isCategoriesLoading = false;
      notifyListeners();
    }
  }

  getProducts(accessToken, String branchCode) async {
    List sample = [];
    _productList = null;
    _isProductsLoading = true;
    notifyListeners();
    try {
      dioRequest.options.headers.addAll({'Authorization': 'Bearer $accessToken'});
      var response = await dioRequest.get('products?branchCode=$branchCode');
      print('product response :::  ${response.data}');
      if (response.data.runtimeType != sample.runtimeType) _productList = ProductsList.fromJson(response.data);
      _isProductsLoading = false;
      print('products added successfully');
      notifyListeners();
    } catch (e) {
      print('products ::: ' + e);
      _isProductsLoading = false;
      notifyListeners();
    }
  }

  getCombos(accessToken, String branchCode) async {
    List sample = [];
    _combosList = null;
    _isProductsLoading = true;
    notifyListeners();
    try {
      dioRequest.options.headers.addAll({'Authorization': 'Bearer $accessToken'});
      var response = await dioRequest.get('combos?branchCode=$branchCode');
      print('Combo response ::: ${response.data}');
      if (response.data.runtimeType != sample.runtimeType) _combosList = CombosList.fromJson(response.data);
      _isProductsLoading = false;
      print('combo added successfully');

      notifyListeners();
    } catch (e) {
      print('combo ::: ' + e);
      _isProductsLoading = false;
      notifyListeners();
    }
  }

  getTrendingOrders(accessToken, String branchCode) async {
    List sample = [];
    _trendingOrders = [];
    _isProductsLoading = true;
    notifyListeners();
    try {
      dioRequest.options.headers.addAll({'Authorization': 'Bearer $accessToken'});
      var response = await dioRequest.get('trending/orders?branchCode=$branchCode');
      print(response.data);
      if (response.data.runtimeType != sample.runtimeType) {
        response.data['result'].forEach((v) {
          _trendingOrders.add(new CommonProduct.fromJson(v));
        });
        print(_trendingOrders.length);
      }
      print('Success');
      _isProductsLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _trendingOrders = [];
      _isProductsLoading = false;
      notifyListeners();
    }
  }

  Product getProductById(String productCode) {
    Product product;
    if (productList?.productsList != null) {
      for (int i = 0; i < productList.productsList.length; i++) {
        if (productList.productsList[i].productCode == productCode) {
          product = productList.productsList[i];
        }
      }
    }
    return product;
  }

  Combo getComboById(String comboCode) {
    Combo product;
    if (combosList?.combosList != null) {
      for (int i = 0; i < combosList.combosList.length; i++) {
        if (combosList.combosList[i].comboCode == comboCode) {
          product = combosList.combosList[i];
        }
      }
    }
    return product;
  }
}
