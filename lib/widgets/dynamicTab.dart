import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/model/transaction_type.dart';
import 'package:track_my_wallet_finance_app/ui_models/transactionWithCategory.dart';
import 'package:track_my_wallet_finance_app/widgets/transcationContent.dart';
import '../Repository/category_provider.dart';
import '../Repository/transaction_provider.dart';

class DynamicTab extends StatefulWidget {
  final bool limitToLatestGroup;
  final Widget? trailing;
  final int initialSelectedIndex;
  
  const DynamicTab({super.key, this.limitToLatestGroup = false, this.trailing, this.initialSelectedIndex = 0});

  @override
  _DynamicTabState createState() => _DynamicTabState();
}

class _DynamicTabState extends State<DynamicTab> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    if (!provider.isLoaded) {
      return Center(child: CircularProgressIndicator(color: kBlackColor));
    }

    final transactions = provider.transactions;
    final categoryProvider = context.read<CategoryProvider>();
    
    final allItems = transactions.map((tx) {
      final category = categoryProvider.getCategoryById(tx.categoryId);
      return TransactionWithCategory(category: category, transaction: tx);
    }).toList();

    List<TransactionWithCategory> displayedItems;
    if (_selectedIndex == 0) {
      displayedItems = allItems;
    } else if (_selectedIndex == 1) {
      displayedItems = allItems
          .where((e) => e.transaction.type == TransactionType.income)
          .toList();
    } else {
      displayedItems = allItems
          .where((e) => e.transaction.type == TransactionType.expense)
          .toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        // Custom Tab Selector
        SizedBox(
          height: 40,
          child: Row(
            children: [
              _buildTabButton("All", 0),
              const SizedBox(width: 8),
              _buildTabButton("Income", 1),
              const SizedBox(width: 8),
              _buildTabButton("Expense", 2),
              if (widget.trailing != null) ...[
                const Spacer(),
                widget.trailing!,
              ],
            ],
          ),
        ),
        
        // Animated Switcher for smooth content transitions
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(_selectedIndex),
              child: TranscationContent(
                transactions: displayedItems,
                limitToLatestGroup: widget.limitToLatestGroup,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (_selectedIndex != index) {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? kBlackColor : kWhiteColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
          border: isSelected
              ? null
              : Border.all(color: kBlackColor.withValues(alpha: 0.1), width: 1),
        ),
        child: Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: isSelected? 14:12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            color: isSelected ? kWhiteColor : kBlackColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
