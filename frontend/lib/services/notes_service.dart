import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/models/note.dart';
import 'package:frontend/services/api_service.dart';

part 'notes_service.g.dart';

@riverpod
NotesService notesService(Ref ref) {
  final dio = ref.watch(apiServiceProvider);
  return NotesService(dio);
}

class NotesService {
  final Dio _dio;

  NotesService(this._dio);

  Future<List<Note>> getNotes() async {
    try {
      final response = await _dio.get('/notes');
      return (response.data as List).map((e) => Note.fromJson(e)).toList();
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? 'Failed to fetch notes';
    }
  }

  Future<Note> createNote(String title, String content) async {
    try {
      final response = await _dio.post('/notes', data: {
        'title': title,
        'content': content,
      });
      return Note.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? 'Failed to create note';
    }
  }

  Future<Note> updateNote(int id, String title, String content) async {
    try {
      final response = await _dio.patch('/notes/$id', data: {
        'title': title,
        'content': content,
      });
      return Note.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? 'Failed to update note';
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _dio.delete('/notes/$id');
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? 'Failed to delete note';
    }
  }
}
