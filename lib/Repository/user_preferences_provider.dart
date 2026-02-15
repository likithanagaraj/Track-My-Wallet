import 'package:flutter/material.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_repository.dart';
import 'package:track_my_wallet_finance_app/model/user_preferences.dart';

class UserPreferencesProvider extends ChangeNotifier {
  final UserPreferencesRepository _repo = UserPreferencesRepository();
  UserPreferences? _preferences;
  bool _isLoading = true;

  UserPreferences? get preferences => _preferences;
  bool get isLoading => _isLoading;
  
  String get currencySymbol => _preferences?.currencySymbol ?? '₹';
  String get userName => _preferences?.userName ?? 'User';

  UserPreferencesProvider() {
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    _isLoading = true;
    notifyListeners();
    
    _preferences = await _repo.getUserPreferences();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    await _repo.updateUserName(name);
    await loadPreferences();
  }

  Future<void> updateCurrency(String currency, String symbol) async {
    await _repo.updateCurrency(currency, symbol);
    await loadPreferences();
  }
}
