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
import 'package:fl_chart/fl_chart.dart';
import 'package:track_my_wallet_finance_app/widgets/route_animations.dart';
import 'package:track_my_wallet_finance_app/screens/transcationScreen.dart';
import 'package:track_my_wallet_finance_app/widgets/space_trend_chart.dart';
import 'package:track_my_wallet_finance_app/widgets/appScreenBackground.dart';

class SpaceDetailsScreen extends StatefulWidget {
  final EventModel event;

  const SpaceDetailsScreen({super.key, required this.event});

  @override
  State<SpaceDetailsScreen> createState() => _SpaceDetailsScreenState();
}

class _SpaceDetailsScreenState extends State<SpaceDetailsScreen> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final symbol = context.watch<UserPreferencesProvider>().currencySymbol;
    final categoryProvider = context.read<CategoryProvider>();

    final spaceTransactions = transactionProvider.transactions
        .where((t) => t.eventId == widget.event.id)
        .map((tx) {
          final category = categoryProvider.getCategoryById(tx.categoryId);
          return TransactionWithCategory(category: category, transaction: tx);
        })
        .toList();

    final totalSpent = spaceTransactions.fold<double>(0, (sum, t) => sum + t.transaction.amount);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScreenBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 20, top: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(FluentIcons.chevron_left_24_regular, color: kBlackColor),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.event.name,
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: kBlackColor.withValues(alpha: 0.9),
                        letterSpacing: -0.8,
                      ),
                    ),
                    const Spacer(),
                    AppCloseButton(onTap: () => Navigator.pop(context)),
                  ],
                ),
              ),

              // SCROLLABLE CONTENT
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HERO SECTION
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: kBlackColor.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Total Spent",
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kBlackColor.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatCurrency(totalSpent, symbol: symbol),
                              style: GoogleFonts.manrope(
                                color: kBlackColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 42,
                                letterSpacing: -1.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: kBlackColor.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${widget.event.createdAt.day} ${_getMonthName(widget.event.createdAt.month)}, ${widget.event.createdAt.year}",
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: kBlackColor.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // BAR CHART SECTION
                      Text(
                        "Category Breakdown",
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: kBlackColor,
                          letterSpacing: -0.5
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildHorizontalBarChart(spaceTransactions, symbol),

                      const SizedBox(height: 32),

                      // TRANSACTIONS LIST
                      if (spaceTransactions.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "History",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: kBlackColor,
                                letterSpacing: -0.5
                              ),
                            ),
                            Text(
                              "${spaceTransactions.length} Transactions",
                               style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kBlackColor.withValues(alpha: 0.5)
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: kBlackColor.withValues(alpha: 0.05),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: TranscationContent(
                                  transactions: spaceTransactions,
                                  isScrollable: false,
                                ),
                              ),
                            ),
                        const SizedBox(height: 40),
                      ] else ...[
                        _buildEmptyState(context),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalBarChart(List<TransactionWithCategory> transactions, String symbol) {
     if (transactions.isEmpty) return const SizedBox();
    final breakdown = _getBreakdown(transactions);
    final sortedItems = breakdown.values.toList()..sort((a, b) => b.amount.compareTo(a.amount));
    final displayItems = sortedItems.take(5).toList();
    final maxAmount = displayItems.first.amount; // Since sorted desc

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(24),
         boxShadow: [BoxShadow(color: kBlackColor.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: displayItems.map((item) {
          final percentage = item.amount / maxAmount;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.icon, size: 16, color: item.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.label, style: GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 13)),
                          Text(formatCurrency(item.amount, symbol: symbol, decimalDigits: 0), style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Stack(
                        children: [
                          Container(
                            height: 6,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kBlackColor.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: percentage,
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: item.color,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            SmoothPageRoute(page: TransactionScreen(initialEventId: widget.event.id)),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: kBlackColor.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FluentIcons.receipt_add_24_regular, color: kOrangeColor, size: 32),
              const SizedBox(height: 12),
              Text(
                "No transactions in this space yet",
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: kBlackColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Tap here to add a new record to ${widget.event.name}",
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: kBlackColor.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Map<String, ({String label, double amount, IconData icon, Color color})> _getBreakdown(List<TransactionWithCategory> transactions) {
     final Map<String, ({String label, double amount, IconData icon, Color color})> breakdown = {};
    for (var item in transactions) {
      final key = item.category.id;
      if (breakdown.containsKey(key)) {
        breakdown[key] = (
          label: breakdown[key]!.label,
          amount: breakdown[key]!.amount + item.transaction.amount,
          icon: breakdown[key]!.icon,
          color: breakdown[key]!.color,
        );
      } else {
         // App specific palette
        const palette = [kBlackColor, Color(0xFF3B82F6), kOrangeColor, kGreenColor];
        breakdown[key] = (
          label: item.category.categoryLabel,
          amount: item.transaction.amount,
          icon: item.category.categoryIcon,
          color: palette[breakdown.length % palette.length],
        );
      }
    }
    return breakdown;
  }


}