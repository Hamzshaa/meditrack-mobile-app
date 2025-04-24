import 'package:dio/dio.dart';
import 'package:meditrack/core/constants.dart';

Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ),
  );

  return dio;
}
