import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider of the [SharedPreferencesService].
///
/// Needs to be overriden after [SharedPreferences] instance has been initialized
final sharedPreferencesServiceProvider =
    Provider.autoDispose<SharedPreferencesService>(
  (ref) => throw UnimplementedError(),
);

class SharedPreferencesService {
  SharedPreferencesService(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  /// Fetch a string from Local Storage ([SharedPreferences]).
  ///
  /// If you're getting an object don't forget to convert it with a fromJson method.
  String? getStringFromSharedPreferences(String key) {
    return _sharedPreferences.getString(key);
  }

  /// Fetch a list of strings from Local Storage ([SharedPreferences]).
  List<String>? getListOfStringsFromSharedPreferences(String key) {
    return _sharedPreferences.getStringList(key);
  }

  /// Fetch a bool from Local Storage ([SharedPreferences]).
  bool? getBoolFromSharedPreferences(String key) {
    return _sharedPreferences.getBool(key);
  }

  /// Fetch an int from Local Storage ([SharedPreferences]).
  int? getIntFromSharedPreferences(String key) {
    return _sharedPreferences.getInt(key);
  }

  /// Fetch a double from Local Storage ([SharedPreferences]).
  double? getDoubleFromSharedPreferences(String key) {
    return _sharedPreferences.getDouble(key);
  }

  /// Content can be either a string, bool, int or double.
  ///
  /// If you want to save a different type, try saving it with a toJSon method.
  /// To save a list of type string, call `saveListOfStringsToSharedPreferences`
  Future<bool> saveToSharedPreferences<T>(String key, T value) async {
    switch (value.runtimeType) {
      case const (List<String>):
        return await _sharedPreferences.setStringList(
            key, value as List<String>);
      case const (String):
        return await _sharedPreferences.setString(key, value as String);
      case const (bool):
        return await _sharedPreferences.setBool(key, value as bool);
      case const (int):
        return await _sharedPreferences.setInt(key, value as int);
      case const (double):
        return await _sharedPreferences.setDouble(key, value as double);
      default:
        throw Exception(
            'Can\'t save content of type ${value.runtimeType}. Content should of types String, bool, int, double or List<String>. Try passing the object as a JSON encoded String with a toJson method');
    }
  }

  /// Removes a key from Local Storage ([SharedPreferences]).
  Future<bool> removeFromSharedPreferences(String key) {
    return _sharedPreferences.remove(key);
  }

  /// Removes all keys from Local Storage ([SharedPreferences]).
  Future<bool> clearSharedPreferences() {
    return _sharedPreferences.clear();
  }
}
