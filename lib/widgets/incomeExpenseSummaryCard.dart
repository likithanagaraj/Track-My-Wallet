import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/Repository/transaction_provider.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_provider.dart';
import 'package:track_my_wallet_finance_app/helperFunction.dart';
import 'package:track_my_wallet_finance_app/widgets/route_animations.dart';
import 'package:track_my_wallet_finance_app/screens/AllTransactionsScreen.dart';

class IncomeExpenseSummaryCard extends StatelessWidget {
  const IncomeExpenseSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final userPrefs = context.watch<UserPreferencesProvider>();
    final symbol = userPrefs.currencySymbol;
    final income = provider.getIncome();
    final expense = provider.getExpense();
    final topCategories = provider.getTopExpenseCategories();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // LEFT COLUMN
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _smallCard(context, "Expenses", expense, symbol, 2)),
              const SizedBox(height: 4),
              Expanded(child: _smallCard(context, "Income", income, symbol, 1)),
            ],
          ),
        ),

        const SizedBox(width: 4),

        // RIGHT SIDE
        Expanded(flex: 1, child: _mostSpentCard(topCategories)),
      ],
    );
  }

  // ================= SMALL CARD =================

  Widget _smallCard(BuildContext context, String title, double value, String symbol, int initialIndex) {
    // If value is under 1000, add decimal
    final displayValue = (value < 1000) 
        ? formatCurrency(value, symbol: symbol, decimalDigits: 2)
        : formatCurrency(value, symbol: symbol, decimalDigits: 0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SmoothPageRoute(page: AllTransactionsScreen(initialIndex: initialIndex)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: kBlackColor.withValues(alpha: 0.6),
                      letterSpacing: 0
                  ),
                ),
                Icon(FontAwesomeIcons.angleRight, size: 14, color: kBlackColor.withValues(alpha: 0.4),)
              ],
            ),
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutQuart,
                tween: Tween<double>(begin: 0, end: value),
                builder: (context, val, child) {
                  // Re-evaluate decimal for the animated value too
                  final animatedDisplay = (val < 1000) 
                      ? formatCurrency(val, symbol: symbol, decimalDigits: 2)
                      : formatCurrency(val, symbol: symbol, decimalDigits: 0);
                  
                  return Text(
                    animatedDisplay,
                    style: GoogleFonts.manrope(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: kBlackColor.withValues(alpha: 0.8),
                      letterSpacing: -0.5,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MOST SPENT CARD =================

  Widget _mostSpentCard(
    List<({String id, String label, double amount, IconData icon})> categories,
  ) {
    final items = categories.take(3).toList();
    final count = items.length;

    final spacing = count == 1 ? 16.0 : (count == 2 ? 10.0 : 4.0);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Most Spent on",
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: kBlackColor.withValues(alpha: 0.6),
              letterSpacing: 0
            ),
          ),

          const SizedBox(height: 12),

          if (items.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kscaffolBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        FluentIcons.data_usage_24_regular,
                        size: 28,
                        color: kBlackColor.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "No spending habits yet. Start tracking to see your patterns.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          color: kBlackColor.withValues(alpha: 0.4),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(items.length, (index) {
                  return Column(
                    children: [
                      _BarItem(
                        label: items[index].label,
                        amount: items[index].amount,
                        maxAmount: categories.first.amount,
                        icon: items[index].icon,
                        index: index,
                      ),
                      if (index != items.length - 1) SizedBox(height: spacing),
                    ],
                  );
                }),
                if (items.length < 2) ...[
                  const SizedBox(height: 12),
                  Text(
                    "Tracking more categories helps you understand your spending better.",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.manrope(
                      color: kBlackColor.withOpacity(0.4),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ]
              ],
            ),
        ],
      ),
    );
  }
}

// ================= ANIMATED BAR ITEM =================

class _BarItem extends StatelessWidget {
  final String label;
  final double amount;
  final double maxAmount;
  final IconData icon;
  final int index;

  const _BarItem({
    required this.label,
    required this.amount,
    required this.maxAmount,
    required this.icon,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxAmount > 0 ? (amount / maxAmount).clamp(0.0, 1.0) : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final targetWidth = totalWidth * ratio;
        const minWidth = 36.0;

        return Stack(
          children: [
            // Background
            Container(
              height: 28,
              decoration: BoxDecoration(
                color: kscaffolBg,
                borderRadius: BorderRadius.circular(30),
              ),
            ),

            // Animated Filled bar
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 1000 + (index * 200)),
              curve: Curves.elasticOut,
              tween: Tween<double>(
                begin: 0,
                end: targetWidth < minWidth ? minWidth : targetWidth,
              ),
              builder: (context, width, child) {
                final showText = width > 50;
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: width,
                    height: 28,
                    decoration: BoxDecoration(
                      color: kOrangeColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: kOrangeColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Row(
                      children: [
                        // Badge
                        Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            icon,
                            size: 14,
                            color: kBlackColor.withValues(alpha: 0.8),
                          ),
                        ),

                        if (showText) const SizedBox(width: 6),

                        if (showText)
                          Expanded(
                            child: Text(
                              label.toLowerCase(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
