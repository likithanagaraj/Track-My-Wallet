import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/screens/transcationScreen.dart';
import 'package:track_my_wallet_finance_app/widgets/transcationCard.dart';
import 'package:track_my_wallet_finance_app/widgets/dynamicTab.dart';
import 'package:track_my_wallet_finance_app/widgets/floatingActionNavigatorButton.dart';
import '../Repository/transaction_provider.dart';
import 'package:animations/animations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void openAddTransaction() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute(builder: (_) => const TransactionScreen()));
    print("Trans Screen");
  }

  @override
  Widget build(BuildContext context) {
    final income = context.watch<TransactionProvider>().getIncome();
    final expense = context.watch<TransactionProvider>().getExpense();
    final provider = context.read<TransactionProvider>();
    if (!provider.isLoaded) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: kBlackColor)),
      );
    }
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: OpenContainer(
        closedElevation: 0,
        openElevation: 0,
        closedColor: Colors.transparent,
        openColor: Colors.transparent,
        openShape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20)
        ),

        closedBuilder: (context,closeContainer){
          return FloatingActionNavigatorButton(
            onTap: closeContainer,
          );
        },
        openBuilder:(context,openConatiner){
          return TransactionScreen();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Welcome', style: kWelcomeText),
                  Image.asset('images/wave.png', height: 50.0, width: 50.0),
                ],
              ),
              SizedBox(height: 6),
              IntrinsicHeight(
                child: Row(
                  spacing: 10.0,
                  children: [
                    Expanded(
                      child: TranscationCard(
                        label: 'Income',
                        value: '₹$income',
                        rotateNumber: 45,
                      ),
                    ),
                    Expanded(
                      child: TranscationCard(
                        label: 'Expenses',
                        value: '₹$expense',
                        rotateNumber: 225,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(child: DynamicTab()),
            ],
          ),
        ),
      ),
    );
  }
}
