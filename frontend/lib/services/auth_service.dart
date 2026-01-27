import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/models/auth_response.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api_service.dart';

part 'auth_service.g.dart';

@riverpod
AuthService authService(Ref ref) {
  final dio = ref.watch(apiServiceProvider);
  return AuthService(dio);
}

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<AuthResponse> login(String email, String password) async {
    try {
      // The backend expects x-www-form-urlencoded or multipart for OAuth2 password flow usually,
      // BUT the prompt says "POST /auth/login" and "Email, Password".
      // Assuming JSON body based on "Note content (multi-line)" description style 
      // but commonly FastAPi uses OAuth2PasswordRequestForm.
      // Let's assume standard JSON for now as per "POST /auth/login" description.
      // If it fails, I'll switch to FormData.
      final response = await _dio.post('/auth/login', data: {
        'username': email, // FastAPI OAuth2PasswordRequestForm uses 'username' often, but user said 'email'.
        // Let's stick to the prompt's likely intent: JSON body with email/password
        'email': email,
        'password': password,
      });
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? 'Login failed';
    }
  }
  
  // NOTE: If the backend is strict FastAPI OAuth2, login might need `FormData.fromMap({'username': email, 'password': password})`
  // and content-type `application/x-www-form-urlencoded`.

  Future<void> register(String name, String email, String password) async {
     try {
      await _dio.post('/auth/register', data: {
        'full_name': name,
        'email': email,
        'password': password,
      });
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? 'Registration failed';
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      return User.fromJson(response.data);
    } on DioException catch (e) {
       throw e.response?.data['detail'] ?? 'Failed to fetch user';
    }
  }
}
