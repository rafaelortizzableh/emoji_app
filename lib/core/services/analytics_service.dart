import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dead_simple_analytics.dart';

final analyticsServiceProvider = Provider.autoDispose<AnalyticsService>(
  (ref) {
    if (kDebugMode) {
      return _DebugAnalyticsService();
    }
    return _DeadSimpleAnalyticsService(ref.watch(_deadSimpleAnalyticsProvider));
  },
);

final _deadSimpleAnalyticsProvider =
    Provider.autoDispose<DeadSimpleAnalytics>((ref) {
  return DeadSimpleAnalytics();
});

abstract class AnalyticsService {
  void emitEvent(String eventName, Map<String, dynamic> eventProperties);
  void identifyUser(String userId);
}

class _DebugAnalyticsService implements AnalyticsService {
  @override
  void emitEvent(String eventName, Map<String, dynamic> eventProperties) {
    log('🧿 Analytics -> Event: $eventName, Properties: $eventProperties');
  }

  @override
  void identifyUser(String userId) {
    log('🧿 Analytics -> User identified: $userId');
  }
}

class _DeadSimpleAnalyticsService implements AnalyticsService {
  final DeadSimpleAnalytics _deadSimpleAnalytics;

  _DeadSimpleAnalyticsService(this._deadSimpleAnalytics);

  final _eventDebouncer = <String, DateTime>{};

  @override
  Future<void> emitEvent(
    String eventName,
    Map<String, dynamic> eventProperties,
  ) async {
    final lastSent = _eventDebouncer[eventName];

    if (lastSent != null) {
      final alreadyBeingSent =
          DateTime.now().difference(lastSent) < const Duration(seconds: 1);

      if (alreadyBeingSent) {
        return;
      }
    }

    final now = DateTime.now();
    _eventDebouncer[eventName] = now;
    final timestamp = now;
    try {
      await _deadSimpleAnalytics.capture(
        eventName,
        properties: eventProperties,
        timestamp: timestamp,
      );
    } catch (e) {
      debugPrint('Error sending event to DeadSimpleAnalytics: $e');
    } finally {
      _eventDebouncer.remove(eventName);
    }
  }

  @override
  void identifyUser(String userId) {
    _deadSimpleAnalytics.setUserId(userId);
  }
}
