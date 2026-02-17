import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/ui_models/transactionWithCategory.dart';
import 'package:track_my_wallet_finance_app/screens/transcationScreen.dart';
import 'package:track_my_wallet_finance_app/widgets/empty_transactions_widget.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_provider.dart';
import 'package:track_my_wallet_finance_app/helperFunction.dart';
import 'package:track_my_wallet_finance_app/widgets/route_animations.dart';
import 'package:track_my_wallet_finance_app/Repository/transaction_provider.dart';
import 'package:track_my_wallet_finance_app/model/transaction_type.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class TranscationContent extends StatelessWidget {
  final List<TransactionWithCategory> transactions;
  final bool limitToLatestGroup;
  final bool hideTotal;
  final bool isScrollable;

  const TranscationContent({
    super.key, 
    required this.transactions, 
    this.limitToLatestGroup = false,
    this.hideTotal = false,
    this.isScrollable = true,
  });

  String _getGroupLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) return 'Today';
    if (checkDate == yesterday) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return EmptyTransactionsWidget(
        onAddTap: () {
          Navigator.of(context, rootNavigator: true).push(
            SmoothPageRoute(page: const TransactionScreen()),
          );
        },
      );
    }

    final symbol = context.watch<UserPreferencesProvider>().currencySymbol;

    final Map<String, List<TransactionWithCategory>> groupedTransactions = {};
    final sortedTxs = List<TransactionWithCategory>.from(transactions)
      ..sort((a, b) => b.transaction.createdAt.compareTo(a.transaction.createdAt));

    for (var tx in sortedTxs) {
      final label = _getGroupLabel(tx.transaction.createdAt);
      groupedTransactions.putIfAbsent(label, () => []).add(tx);
    }

    var groups = groupedTransactions.keys.toList();
    if (limitToLatestGroup && groups.isNotEmpty) groups = [groups.first];

    Widget buildGroup(String label) {
      final groupItems = groupedTransactions[label]!;
      final totalAmount = groupItems.fold<double>(0, (sum, item) => sum + item.transaction.amount);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GroupHeader(label: label, totalAmount: totalAmount, symbol: symbol, hideTotal: hideTotal),
          const Divider(thickness: 0.3, color: Colors.grey),
          ...groupItems.asMap().entries.map((entry) {
            return _TransactionItem(
              tx: entry.value,
              symbol: symbol,
              index: entry.key,
            );
          }),
          const SizedBox(height: 24),
        ],
      );
    }

    if (!isScrollable) {
      return Column(
        children: groups.map((label) => buildGroup(label)).toList(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, bottom: 80),
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) => buildGroup(groups[groupIndex]),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String label;
  final double totalAmount;
  final String symbol;
  final bool hideTotal;

  const _GroupHeader({
    required this.label, 
    required this.totalAmount, 
    required this.symbol,
    required this.hideTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: kBlackColor.withValues(alpha: 0.5),
            ),
          ),
          if (!hideTotal)
            Text(
              formatCurrency(totalAmount, symbol: symbol),
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: kBlackColor,
                letterSpacing: -0.1
              ),
            ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final TransactionWithCategory tx;
  final String symbol;
  final int index;

  const _TransactionItem({required this.tx, required this.symbol, required this.index});

  @override
  Widget build(BuildContext context) {
    final hasNote = tx.transaction.note != null && tx.transaction.note!.trim().isNotEmpty;
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Dismissible(
              key: Key(tx.transaction.id),
              direction: DismissDirection.horizontal,
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  // Swipe Right (Edit)
                  Navigator.of(context, rootNavigator: true).push(
                    SmoothPageRoute(
                      page: TransactionScreen(existingTransaction: tx.transaction),
                    ),
                  );
                  return false; // Don't dismiss, just navigate
                } else {
                  // Swipe Left (Delete)
                  return await _showDeleteConfirmation(context);
                }
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  context.read<TransactionProvider>().deleteTransaction(tx.transaction.id);
                }
              },
              background: _buildSwipeBackground(
                color: kBlackColor.withValues(alpha: 0.05),
                icon: FluentIcons.edit_24_regular,
                alignment: Alignment.centerLeft,
                label: "Edit",
              ),
              secondaryBackground: _buildSwipeBackground(
                color: Colors.red.withValues(alpha: 0.05),
                icon: FluentIcons.delete_24_regular,
                alignment: Alignment.centerRight,
                label: "Delete",
                textColor: Colors.red,
              ),
              child: child!,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Expanded( // 👈 KEY FIX
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: kWhiteColor,
                    radius: 16,
                    child: Icon(
                      tx.category.categoryIcon, 
                      size: 16, 
                      color:kBlackColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded( // 👈 also constrain the text column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasNote ? tx.transaction.note! : tx.category.categoryLabel,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (hasNote)
                          Text(
                            tx.category.categoryLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: kBlackColor.withValues(alpha: 0.5),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: Text(
                "${tx.transaction.type == TransactionType.income ? '+' : '-'}${formatCurrency(tx.transaction.amount, symbol: symbol)}",
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: tx.transaction.type == TransactionType.income ? kGreenColor : kRedColor,
                ),
              ),
            ),
          ],
        )

      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kWhiteColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "Delete Transaction?",
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: Text(
          "This action cannot be undone and will be removed from your records.",
          style: GoogleFonts.manrope(fontWeight: FontWeight.w500, color: kBlackColor.withValues(alpha: 0.6), height: 1.5),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cancel", style: GoogleFonts.manrope(color: kBlackColor.withValues(alpha: 0.5), fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Delete", style: GoogleFonts.manrope(color: Colors.red, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Color color,
    required IconData icon,
    required Alignment alignment,
    required String label,
    Color textColor = kBlackColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) ...[
            Icon(icon, color: textColor.withValues(alpha: 0.7), size: 20),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.manrope(color: textColor.withValues(alpha: 0.7), fontWeight: FontWeight.w700, fontSize: 13)),
          ],
          if (alignment == Alignment.centerRight) ...[
            Text(label, style: GoogleFonts.manrope(color: textColor.withValues(alpha: 0.7), fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(width: 8),
            Icon(icon, color: textColor.withValues(alpha: 0.7), size: 20),
          ],
        ],
      ),
    );
  }
}
