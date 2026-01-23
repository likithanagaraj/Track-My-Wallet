import 'package:flutter/material.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/model/transaction_type.dart';
import 'package:track_my_wallet_finance_app/ui_models/transactionWithCategory.dart';
import 'package:track_my_wallet_finance_app/widgets/transcationContent.dart';

import '../Repository/category_provider.dart';
import '../Repository/transaction_provider.dart';

class DynamicTab extends StatelessWidget {
  bool isScrollable = true;
  bool showNextIcon = false;
  bool showBackIcon = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    if (!provider.isLoaded) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: kBlackColor)),
      );
    }
    final transactions = context.watch<TransactionProvider>().transactions;
    final categoryProvider = context.read<CategoryProvider>();

    final item = transactions.map((tx) {
      final category = categoryProvider.getCategoryById(tx.categoryId);
      return TransactionWithCategory(category: category, transaction: tx);
    }).toList();

    final incomeItems = item
        .where((e) => e.transaction.type == TransactionType.income)
        .toList();

    final expenseItems = item
        .where((e) => e.transaction.type == TransactionType.expense)
        .toList();

    List<TabData> tabs = [
      TabData(
        index: 1,
        title: const Tab(text: 'All'),
        content: TranscationContent(transactions: item),
      ),
      TabData(
        index: 2,
        title: const Tab(text: 'Income'),
        content: TranscationContent(transactions: incomeItems),
      ),
      TabData(
        index: 3,
        title: const Tab(text: 'Expense'),
        content: TranscationContent(transactions: expenseItems),
      ),
    ];

    return DynamicTabBarWidget(
      labelPadding: EdgeInsets.only(right: 30.0),
      dynamicTabs: tabs,
      onTabControllerUpdated: (controller) {},
      isScrollable: isScrollable,
      showBackIcon: showBackIcon,
      showNextIcon: showNextIcon,
      tabAlignment: TabAlignment.start,
      onTabChanged: (index) {},
      overlayColor: WidgetStateColor.transparent,
      unselectedLabelStyle: GoogleFonts.poppins(
        letterSpacing: 0,
        color: kBlackColor.withValues(alpha: 0.5),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: GoogleFonts.poppins(
        letterSpacing: -0.2,
        color: kBlackColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      indicator: BoxDecoration(),
      dividerHeight: 0,
    );
  }
}
