import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/models/note.dart';
import 'package:frontend/services/notes_service.dart';

part 'notes_provider.g.dart';

@riverpod
class Notes extends _$Notes {
  @override
  FutureOr<List<Note>> build() async {
    final service = ref.read(notesServiceProvider);
    return await service.getNotes();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(notesServiceProvider);
      return await service.getNotes();
    });
  }

  Future<void> addNote(String title, String content) async {
    final service = ref.read(notesServiceProvider);
    await service.createNote(title, content);
    // Optimistic update or refresh? Refresh is safer.
    ref.invalidateSelf();
    await future;
  }

  Future<void> editNote(int id, String title, String content) async {
    final service = ref.read(notesServiceProvider);
    await service.updateNote(id, title, content);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteNote(int id) async {
    final service = ref.read(notesServiceProvider);
    await service.deleteNote(id);
    // Optimistic update
    final previousState = state.value;
    if (previousState != null) {
      state = AsyncValue.data(previousState.where((n) => n.id != id).toList());
    }
    // Also invalidate to be sure
    ref.invalidateSelf();
  }
}
