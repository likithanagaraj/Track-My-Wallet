import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/Repository/category_provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/model/transaction_type.dart';
import 'package:track_my_wallet_finance_app/screens/splashScreen.dart';
import 'Repository/transaction_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/transactionModel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  await Hive.openBox<TransactionModel>('transactions');

  return  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TransactionProvider>(
          create: (_)=>TransactionProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_)=>CategoryProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor:kscaffolBg,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor:kButtonColor,
            foregroundColor: kWhiteColor,
            shape: CircleBorder(),
          )
        ),
        home: const  SplashScreen(),
      ),
    )
  );
}


