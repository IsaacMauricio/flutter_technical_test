import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_env.dart';

class AppHttpClient {
  AppHttpClient._();

  late Dio _dio;

  static AppHttpClient? _httpClient;

  static AppHttpClient get instance {
    if (_httpClient != null) return _httpClient!;

    _httpClient = AppHttpClient._();
    _httpClient!._setupDio();

    return _httpClient!;
  }

  void _setupDio() {
    _dio = Dio();
    _dio.options.baseUrl = dotenv.env[AppEnv.apiUrl] ?? '';
    _dio.options.connectTimeout = const Duration(minutes: 1);
    _dio.options.receiveTimeout = const Duration(minutes: 1);
    _dio.options.contentType = Headers.jsonContentType;

    _dio.interceptors.add(
      LogInterceptor(
        request: false,
        requestHeader: false,
        requestBody: false,
        responseBody: true,
      ),
    );
    _dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    _dio.options.validateStatus = (_) => true;
  }

  Future<T?> request<T>({
    required RequestMethod requestMethod,
    required String url,
    required T? Function(dynamic response) responseParser,
    dynamic body,
    Map<String, dynamic>? query
  }) async {
    try {
      Response response = await _dio.request(
        url,
        data: body,
        queryParameters: query,
        options: Options(
          method: requestMethod.httpMethod
        ),
      );

      if ((response.statusCode ?? 400) < 200 ||
          (response.statusCode ?? 400) > 300) {
        throw DioException.badResponse(
          statusCode: response.statusCode ?? 400,
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      T? parsedResponse = responseParser(response.data);

      if (parsedResponse == null) throw FormatException();

      return parsedResponse;
    } catch (e) {
      rethrow;
    }
  }
}

enum RequestMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE');

  const RequestMethod(this.httpMethod);

  final String httpMethod;
}
