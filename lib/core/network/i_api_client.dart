import 'package:dio/dio.dart';

/// Abstraction for HTTP calls (Dependency Inversion).
abstract class IApiClient {
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  });
}

class DioApiClient implements IApiClient {
  DioApiClient({required this.dio});

  final Dio dio;

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get(path, queryParameters: queryParameters);
  }
}
