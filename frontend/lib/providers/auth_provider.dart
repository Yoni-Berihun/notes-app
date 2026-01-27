import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/storage_service.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<User?> build() async {
    final storage = ref.watch(storageServiceProvider);
    final token = storage.getToken(); // Sync read for speed, or async if needed
    if (token == null) return null;

    try {
      final authService = ref.read(authServiceProvider);
      return await authService.getCurrentUser();
    } catch (e) {
      // Token invalid or expired
      await storage.clearToken();
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final response = await authService.login(email, password);
      
      final storage = ref.read(storageServiceProvider);
      await storage.setToken(response.accessToken);
      
      return await authService.getCurrentUser();
    });
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    // Registration usually doesn't log you in automatically in some APIs, 
    // but often does. The prompt says "Link to Login" on Register screen, 
    // implying Register -> Login manually? 
    // "Register button -> Link to Login".
    // I'll assume register just registers.
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.register(name, email, password);
      // If successful, we are still not logged in (User is null)
      // Or we could auto-login here. 
      // For now, return null (not logged in).
      return null;
    });
  }

  Future<void> logout() async {
    final storage = ref.read(storageServiceProvider);
    await storage.clearToken();
    state = const AsyncValue.data(null);
  }
}
