// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notesService)
final notesServiceProvider = NotesServiceProvider._();

final class NotesServiceProvider
    extends $FunctionalProvider<NotesService, NotesService, NotesService>
    with $Provider<NotesService> {
  NotesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesServiceHash();

  @$internal
  @override
  $ProviderElement<NotesService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotesService create(Ref ref) {
    return notesService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotesService>(value),
    );
  }
}

String _$notesServiceHash() => r'431a8ed19d2b2f75a8db1c8bf56f7d70b037e521';
