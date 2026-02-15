import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 2)
class UserPreferences extends HiveObject {
  @HiveField(0)
  String userName;

  @HiveField(1)
  String currency;

  @HiveField(2)
  String currencySymbol;

  @HiveField(3)
  List<String> appPurposes;

  @HiveField(4)
  bool isOnboardingComplete;

  UserPreferences({
    required this.userName,
    required this.currency,
    required this.currencySymbol,
    required this.appPurposes,
    this.isOnboardingComplete = false,
  });

  String get initials {
    if (userName.isEmpty) return 'U';
    final names = userName.trim().split(' ');
    if (names.length == 1) {
      return names[0][0].toUpperCase();
    }
    return (names[0][0] + names[names.length - 1][0]).toUpperCase();
  }
}
