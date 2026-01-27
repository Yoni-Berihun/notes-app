import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/core/constants.dart';
import 'package:frontend/services/storage_service.dart';

part 'api_service.g.dart';

@riverpod
Dio apiService(Ref ref) {
  final storage = ref.watch(storageServiceProvider);
  
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = storage.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (DioException e, handler) {
      // Handle 401 Unauthorized globally if needed (e.g., logout)
      return handler.next(e);
    },
  ));

  return dio;
}
