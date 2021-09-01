import 'package:alhaji_user_app/models/restaurant-branches.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '/models/user.dart';
import '/utils/dio-request.dart';

class SessionProvider with ChangeNotifier {
  Result _result;
  User _currentUser;
  bool _isLoading = false;
  bool _isBranchesLoading = true;
  String _bearer;
  RestaurantBranch _currentBranch;
  RestaurantBranches _branches;

  //getter
  Result get result => _result;
  User get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isBranchesLoading => _isBranchesLoading;
  String get bearer => _bearer;
  RestaurantBranch get currentBranch => _currentBranch;
  RestaurantBranches get branches => _branches;

  Future<bool> initializeSession(String phoneNumber) async {
    _result = null;
    _currentUser = null;
    try {
      _isLoading = true;
      List sample = [];
      final responce = await dioRequest.get('customers?phoneNumber=$phoneNumber');
      if (responce.data.runtimeType != sample.runtimeType) {
        _result = Result.fromJson(responce.data);
        if (_result.result.isNotEmpty) {
          _currentUser = _result.result[0];
        }
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      await signIn(phoneNumber);
      _isLoading = false;
      print(_currentUser.customerCode);
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signIn(String phoneNumber) async {
    try {
      final responce = await dioRequest.post('customer/signin', data: {"phoneNumber": phoneNumber});
      _bearer = responce.data['token'];
      print(_bearer);
      notifyListeners();
    } on DioError catch (e) {
      print(e.message);
      notifyListeners();
    }
  }

  Future<bool> getBranches() async {
    _isBranchesLoading = true;
    notifyListeners();
    try {
      print(bearer);
      dioRequest.options.headers.addAll({'Authorization': 'Bearer $bearer'});
      var response = await dioRequest.get('branches');
      print(response.data);
      _branches = RestaurantBranches.fromJson(response.data);
      _isBranchesLoading = false;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print(e.response);
      _isBranchesLoading = false;
      notifyListeners();
    }
  }

  changeCurrentBranch(RestaurantBranch branch) {
    if (_currentBranch != null) {
      if (_currentBranch.name != branch.name) {
        _currentBranch = branch;
      }
    } else {
      _currentBranch = branch;
    }
    notifyListeners();
  }
}
