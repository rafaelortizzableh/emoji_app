import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final loggerServiceProvider = Provider.autoDispose<LoggerService>(
  (ref) => DebugPrintLoggerService(),
);

abstract class LoggerService {
  Future<void> identifyUser({int? id});
  Future<void> clearUser();
  void captureMessage(String message, {String? tag});
  void captureException(
    Object exception, {
    StackTrace? stackTrace,
    String? tag,
  });
}

class DebugPrintLoggerService implements LoggerService {
  @override
  Future<void> identifyUser({int? id}) async {
    debugPrint('Identifying user with id: $id');
  }

  @override
  Future<void> clearUser() async {
    debugPrint('Clearing user');
  }

  @override
  void captureMessage(String message, {String? tag}) {
    debugPrint('Capturing message: $message');
  }

  @override
  void captureException(
    Object exception, {
    StackTrace? stackTrace,
    String? tag,
  }) {
    debugPrint('Capturing exception: $exception');
  }
}
