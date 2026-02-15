import 'package:hive_flutter/hive_flutter.dart';
import 'package:track_my_wallet_finance_app/model/user_preferences.dart';

class UserPreferencesRepository {
  static const String _boxName = 'userPreferences';
  
  Future<Box<UserPreferences>> _getBox() async {
    return await Hive.openBox<UserPreferences>(_boxName);
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    final box = await _getBox();
    await box.put('user', preferences);
  }

  Future<UserPreferences?> getUserPreferences() async {
    final box = await _getBox();
    return box.get('user');
  }

  Future<bool> isOnboardingComplete() async {
    final preferences = await getUserPreferences();
    return preferences?.isOnboardingComplete ?? false;
  }

  Future<void> updateUserName(String newName) async {
    final preferences = await getUserPreferences();
    if (preferences != null) {
      preferences.userName = newName;
      await preferences.save();
    }
  }

  Future<void> updateCurrency(String currency, String symbol) async {
    final preferences = await getUserPreferences();
    if (preferences != null) {
      preferences.currency = currency;
      preferences.currencySymbol = symbol;
      await preferences.save();
    }
  }

  Future<void> clearPreferences() async {
    final box = await _getBox();
    await box.clear();
  }
}
