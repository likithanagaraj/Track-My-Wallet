import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/widgets/dynamicTab.dart';
import 'package:track_my_wallet_finance_app/widgets/appScreenBackground.dart';
import 'package:track_my_wallet_finance_app/widgets/transactionLineChart.dart';

class AllTransactionsScreen extends StatelessWidget {
  final int initialIndex;
  const AllTransactionsScreen({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScreenBackground(
        child: Column(
          children: [
            AppBar(
              title: Text(
                "All Transactions",
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: kBlackColor,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              iconTheme: const IconThemeData(color: kBlackColor),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TransactionLineChart(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DynamicTab(limitToLatestGroup: false, initialSelectedIndex: initialIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
