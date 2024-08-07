import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core.dart';

class DeadSimpleAnalytics {
  DeadSimpleAnalytics({
    this.sessionExpiration = const Duration(minutes: 15),
    this.baseUrl = AppConstants.analyticsEndPoint,
    this.debug = kDebugMode,
    this.sharedPreferences,
  });

  /// Create a new sessionId after not sending events for this duration
  final Duration sessionExpiration;

  /// The location of the DeadSimpleAnalytics server
  final String baseUrl;

  /// Debug events are automatically omitted from reports, but are recorded to your database
  final bool debug;

  late final _client = DeadSimpleAnalyticsClient(
    sessionExpiration: sessionExpiration,
    baseUrl: baseUrl,
    debug: debug,
    setString: (key, value) async {
      await _prefs().then((x) => x.setString(key, value));
    },
    getString: (key) async {
      return _prefs().then((x) => x.getString(key));
    },
  );

  /// Provide your own shared preferences instance if you desire
  SharedPreferences? sharedPreferences;

  Future<SharedPreferences> _prefs() async {
    return sharedPreferences ??= await SharedPreferences.getInstance();
  }

  /// Set the current userId. Set it to null to roll a new anonymous userId
  void setUserId(String? userId) async {
    _client.setUserId(userId);
  }

  /// Send an event to the DeadSimpleAnalytics servers.
  ///
  /// Currently uses a best effort online only strategy.
  Future<void> capture(
    String event, {
    Map<String, dynamic> properties = const {},
    DateTime? timestamp,
  }) async {
    await _client.capture(
      event,
      properties: properties,
      timestamp: timestamp,
    );
  }
}

class DeadSimpleAnalyticsClient {
  /// Create a new sessionId after not sending events for this duration
  final Duration sessionExpiration;

  /// The location of the DeadSimple server
  final String baseUrl;

  /// Often set to `kDebugMode` in Flutter
  final bool debug;

  DeadSimpleAnalyticsClient({
    this.sessionExpiration = const Duration(minutes: 15),
    required this.baseUrl,
    this.debug = false,
    this.setString,
    this.getString,
  });

  String? _userId;

  String? get userId => _userId;

  void setUserId(String? value) {
    _userId = value;
    _setUserIdIfNeeded(force: value == null);
    _saveUserId();
  }

  String? _sessionId;

  late final _baseUri = Uri.parse(baseUrl);

  DateTime? _lastSent;

  final Future<void> Function(String key, String value)? setString;

  final Future<String?> Function(String key)? getString;

  /// Send an event to the DeadSimple servers.
  ///
  /// Currently uses a best effort online only strategy.
  Future<void> capture(
    String event, {
    Map<String, dynamic> properties = const {},
    DateTime? timestamp,
  }) async {
    await _setLastSentIfNeeded();
    await _setSessionIdIfNeeded();
    await _setUserIdIfNeeded();

    _lastSent = DateTime.now();
    _saveLastSent();

    final dio = Dio();

    final data = {
      'event': event,
      'userId': userId,
      'sessionId': _sessionId,
      'properties': properties,
      'timestamp': (timestamp ?? DateTime.now()).toUtc().toIso8601String(),
    };
    await dio.postUri(
      _baseUri,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
      ),
    );
  }
}

extension _DeadSimpleSessions on DeadSimpleAnalyticsClient {
  Future<void> _setSessionIdIfNeeded() async {
    _sessionId ??= await _getSessionId() ?? nanoid();

    if (DateTime.now().difference(_lastSent!).abs() > sessionExpiration) {
      _sessionId = nanoid();
    }

    _saveSessionId();
  }

  Future<void> _setUserIdIfNeeded({bool force = false}) async {
    if (force) {
      _userId = ("anon:${nanoid()}");
    } else {
      _userId ??= await _getUserId() ?? ("anon:${nanoid()}");
    }

    _saveUserId();
  }

  Future<void> _setLastSentIfNeeded() async {
    _lastSent ??= await _getLastSent() ?? DateTime.now();
    _saveLastSent();
  }
}

extension _DeadSimpleStorage on DeadSimpleAnalyticsClient {
  static const _sessionIdKey = 'dead-simple-session-id';
  static const _userIdKey = 'dead-simple-user-id';
  static const _lastSentKey = 'dead-simple-last-sent';

  Future<void> _saveSessionId() async {
    final fn = setString;
    final x = _sessionId;
    if (fn == null || x == null) return;
    await fn(_sessionIdKey, x);
  }

  Future<String?> _getSessionId() async {
    final fn = getString;
    if (fn == null) return null;
    return fn(_sessionIdKey);
  }

  Future<void> _saveUserId() async {
    final fn = setString;
    final x = _userId;
    if (fn == null || x == null) return;
    await fn(_userIdKey, x);
  }

  Future<String?> _getUserId() async {
    final fn = getString;
    if (fn == null) return null;
    return fn(_userIdKey);
  }

  Future<void> _saveLastSent() async {
    final fn = setString;
    final x = _lastSent;
    if (fn == null || x == null) return;
    await fn(_lastSentKey, x.toIso8601String());
  }

  Future<DateTime?> _getLastSent() async {
    final fn = getString;
    if (fn == null) return null;
    return DateTime.tryParse(await fn(_lastSentKey) ?? '');
  }
}
