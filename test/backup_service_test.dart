import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:have_to_study/core/providers.dart';
import 'package:have_to_study/core/services/backup_service.dart';
import 'package:have_to_study/data/database/app_database.dart';

void main() {
  test('BackupService exports JSON and restores data cleanly', () async {
    final inMemoryDb = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(inMemoryDb),
      ],
    );

    // Esperar inicialización con datos semilla
    await container.read(subjectsProvider.notifier).createSubject(
      name: 'Inteligencia Artificial',
      code: 'IA-401',
      period: '2024-II',
      iconKey: 'code',
      colorValue: 0xFF2563EB,
    );

    final jsonStr = await BackupService.getBackupJsonString(WidgetRefStub(container));
    final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;

    expect(decoded['version'], 1);
    expect(decoded['subjects'], isA<List>());
    expect((decoded['subjects'] as List).any((s) => s['name'] == 'Inteligencia Artificial'), isTrue);

    // Modificar datos y restaurar
    final backupModified = Map<String, dynamic>.from(decoded);
    backupModified['profile'] = {
      'displayName': 'Carlos Santana',
      'degreeName': 'Ingeniería de Software',
      'academicPeriod': '2025-I',
      'semester': '6° Semestre',
      'avatarPath': null,
    };

    await BackupService.restoreFromJsonString(
      WidgetRefStub(container),
      jsonEncode(backupModified),
    );

    final updatedProfile = container.read(profileProvider);
    expect(updatedProfile.displayName, 'Carlos Santana');
    expect(updatedProfile.degreeName, 'Ingeniería de Software');
  });
}

class WidgetRefStub implements WidgetRef {
  final ProviderContainer container;
  WidgetRefStub(this.container);

  @override
  BuildContext get context => throw UnimplementedError();

  @override
  T read<T>(ProviderListenable<T> provider) => container.read(provider);

  @override
  T watch<T>(ProviderListenable<T> provider) => container.read(provider);

  @override
  bool exists(ProviderBase<Object?> provider) => container.exists(provider);

  @override
  void invalidate(ProviderOrFamily provider) => container.invalidate(provider);

  @override
  void listen<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    container.listen(provider, listener, onError: onError);
  }

  @override
  ProviderSubscription<T> listenManual<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
  }) {
    return container.listen(
      provider,
      listener,
      onError: onError,
      fireImmediately: fireImmediately,
    );
  }

  @override
  T refresh<T>(Refreshable<T> provider) => container.refresh(provider);
}
