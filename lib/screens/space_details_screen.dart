import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/model/eventModel.dart';
import 'package:track_my_wallet_finance_app/Repository/transaction_provider.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_provider.dart';
import 'package:track_my_wallet_finance_app/helperFunction.dart';
import 'package:track_my_wallet_finance_app/widgets/transcationContent.dart';
import 'package:track_my_wallet_finance_app/widgets/closeButton.dart';
import 'package:track_my_wallet_finance_app/Repository/category_provider.dart';
import 'package:track_my_wallet_finance_app/ui_models/transactionWithCategory.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class SpaceDetailsScreen extends StatelessWidget {
  final EventModel event;

  const SpaceDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final symbol = context.watch<UserPreferencesProvider>().currencySymbol;
    final categoryProvider = context.read<CategoryProvider>();
    
    final spaceTransactions = transactionProvider.transactions
        .where((t) => t.eventId == event.id)
        .map((tx) {
          final category = categoryProvider.getCategoryById(tx.categoryId);
          return TransactionWithCategory(category: category, transaction: tx);
        })
        .toList();

    final totalSpent = spaceTransactions.fold<double>(0, (sum, t) => sum + t.transaction.amount);

    return Scaffold(
      backgroundColor: kscaffolBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   CircleAvatar(
                    backgroundColor: const Color(0xFFDBE4F3).withValues(alpha: 0.3),
                    child: Icon(
                      IconData(event.iconCodePoint, fontFamily: 'FluentSystemIcons-Regular', fontPackage: 'fluentui_system_icons'),
                      color: kBlackColor.withValues(alpha: 0.7),
                    ),
                  ),
                  AppCloseButton(onTap: () => Navigator.pop(context)),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Spent",
                              style: GoogleFonts.manrope(
                                color: kBlackColor.withValues(alpha: 0.5),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              formatCurrency(totalSpent, symbol: symbol),
                              style: GoogleFonts.manrope(
                                color: kBlackColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 32,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        event.name,
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: kBlackColor.withValues(alpha: 0.8),
                          letterSpacing: -0.1
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 28),
            
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.95),
                      const Color(0xFFDBE4F3).withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: kBlackColor.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transactions",
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: kBlackColor,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: kWhiteColor.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${spaceTransactions.length} items",
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: kBlackColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TranscationContent(transactions: spaceTransactions),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
