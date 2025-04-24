import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:meditrack/core/dio/dio_client.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(ref) {
  final dio = createDioClient();
  return dio;
}
