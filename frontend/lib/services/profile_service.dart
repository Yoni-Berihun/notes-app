import 'dart:io';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api_service.dart';

part 'profile_service.g.dart';

@riverpod
ProfileService profileService(Ref ref) {
  final dio = ref.watch(apiServiceProvider);
  return ProfileService(dio);
}

class ProfileService {
  final Dio _dio;

  ProfileService(this._dio);

  Future<User> updateProfile({String? name}) async {
    try {
      final response = await _dio.patch('/users/me', data: {
        if (name != null) 'full_name': name,
      });
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? 'Failed to update profile';
    }
  }

  Future<User> uploadAvatar(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '/users/me/avatar',
        data: formData,
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? 'Failed to upload avatar';
    }
  }
}
