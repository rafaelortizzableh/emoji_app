import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';

final shouldIncludeFlagEmojiProvider =
    AsyncNotifierProvider<ShouldIncludeFlagEmojiController, bool>(() {
  return ShouldIncludeFlagEmojiController();
});

class ShouldIncludeFlagEmojiController extends AsyncNotifier<bool> {
  ShouldIncludeFlagEmojiController();

  Future<void> init() async {
    _addListeners();
  }

  static const _tag = 'should_include_flag_emoji_provider';

  void updateValue(bool newValue) async {
    state = AsyncValue.data(newValue);
  }

  Future<bool> _initialize() async {
    try {
      final savedState = ref
          .read(sharedPreferencesServiceProvider)
          .getBoolFromSharedPreferences(_storageKey);

      // Return the state from shared preferences if it exists,
      // otherwise return the default state.
      return savedState ?? false;
    } catch (exception, stackTrace) {
      final logger = ref.read(loggerServiceProvider);
      logger.captureException(
        exception,
        stackTrace: stackTrace,
        tag: _tag,
      );

      return false;
    }
  }

  Future<void> _saveStateToSharedPreferences(bool newState) async {
    try {
      await ref.read(sharedPreferencesServiceProvider).saveToSharedPreferences(
            _storageKey,
            newState,
          );
    } catch (exception, stackTrace) {
      final logger = ref.read(loggerServiceProvider);
      logger.captureException(
        exception,
        stackTrace: stackTrace,
        tag: _tag,
      );
    }
  }

  void _addListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenSelf(
        (previous, next) {
          next.whenData((value) {
            _saveStateToSharedPreferences(value);
          });
        },
      );
    });
  }

  static const _storageKey =
      'should_include_flag_emoji_${AppConstants.configEnvironment}';

  @override
  FutureOr<bool> build() async {
    final initialValue = await _initialize();
    return initialValue;
  }
}
