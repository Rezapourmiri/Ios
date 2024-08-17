import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesMock extends Fake implements SharedPreferences {
  Map<String, dynamic> savedValues = {};

  @override
  Future<bool> setString(String key, String value) async {
    savedValues[key] = value;
    return true;
  }

  @override
  String? getString(String key) {
    dynamic value = savedValues[key];
    return value is String ? value : null;
  }

  @override
  Future<bool> remove(String key) async {
    savedValues.remove(key);
    return true;
  }
}
