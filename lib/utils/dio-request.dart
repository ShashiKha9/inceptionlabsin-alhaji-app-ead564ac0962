import 'package:dio/dio.dart';

import '/utils/commons.dart';

BaseOptions options = BaseOptions(
  baseUrl: Commons.baseURL,
  receiveTimeout: 5000,
);

Dio dioRequest = Dio(options);
