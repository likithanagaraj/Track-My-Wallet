import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/Repository/category_provider.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_repository.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/model/transaction_type.dart';
import 'package:track_my_wallet_finance_app/model/user_preferences.dart';
import 'package:track_my_wallet_finance_app/screens/splashScreen.dart';
import 'package:track_my_wallet_finance_app/screens/homeScreen.dart';
import 'Repository/transaction_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/transactionModel.dart';
import 'model/eventModel.dart';
import 'Repository/event_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(UserPreferencesAdapter());
  Hive.registerAdapter(EventModelAdapter());

  // Open boxes
  await Hive.openBox<TransactionModel>('transactions');
  await Hive.openBox<UserPreferences>('userPreferences');
  await Hive.openBox<EventModel>('events');

  // Check onboarding status
  final userPrefsRepo = UserPreferencesRepository();
  final isOnboardingComplete = await userPrefsRepo.isOnboardingComplete();

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TransactionProvider>(
          create: (_) => TransactionProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider<UserPreferencesProvider>(
          create: (_) => UserPreferencesProvider(),
        ),
        ChangeNotifierProvider<EventProvider>(
          create: (_) => EventProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: kscaffolBg,
          textTheme: GoogleFonts.manropeTextTheme(),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: kButtonColor,
            foregroundColor: kWhiteColor,
            shape: CircleBorder(),
          ),
        ),
        builder: (context,child){
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(1.0)
          ), child: child!);
        },
        home: isOnboardingComplete ? const HomeScreen() : const SplashScreen(),
      ),
    ),
  );
}
