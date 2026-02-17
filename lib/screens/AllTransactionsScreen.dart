import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/widgets/appScreenBackground.dart';
import 'package:track_my_wallet_finance_app/widgets/transcationContent.dart';
import 'package:track_my_wallet_finance_app/widgets/space_trend_chart.dart';
import 'package:track_my_wallet_finance_app/Repository/transaction_provider.dart';
import 'package:track_my_wallet_finance_app/Repository/category_provider.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_provider.dart';
import 'package:track_my_wallet_finance_app/ui_models/transactionWithCategory.dart';
import 'package:track_my_wallet_finance_app/model/transaction_type.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:track_my_wallet_finance_app/helperFunction.dart';

class AllTransactionsScreen extends StatefulWidget {
  final int? initialIndex;

  const AllTransactionsScreen({super.key, this.initialIndex});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  // 0 = Income, 1 = Expense
  int _selectedTabIndex = 1; 

  DateTime _selectedMonth = DateTime.now();
  // Search state is now local to the bottom sheet if we want, but sticking to "search in bottom sheet".
  // Actually, standard pattern is search bar at top of list.
  // The user said "Let the seach icon be inside the bottom Sheet". 
  // This implies the search bar expands there.
  
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    if (widget.initialIndex != null) {
      _selectedTabIndex = widget.initialIndex!;
    }
    // Default to current month
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final categoryProvider = context.read<CategoryProvider>();
    final userPrefs = context.watch<UserPreferencesProvider>();
    
    // 1. Filter by Type
    final type = _selectedTabIndex == 0 ? TransactionType.income : TransactionType.expense;
    
    // 2. Filter by Month
    // Get stats for graph
    final graphData = provider.getMonthlyDailyStats(_selectedMonth, type);

    // Get transactions for list
    final allTransactions = provider.transactions;
    var displayedTransactions = allTransactions.where((t) {
      final matchesType = t.type == type;
      final matchesMonth = t.createdAt.year == _selectedMonth.year && t.createdAt.month == _selectedMonth.month;
      return matchesType && matchesMonth;
    }).toList();

    // 3. Filter by Search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      displayedTransactions = displayedTransactions.where((t) {
        final category = categoryProvider.getCategoryById(t.categoryId);
        final matchesNote = t.note?.toLowerCase().contains(query) ?? false;
        final matchesCategory = category.categoryLabel.toLowerCase().contains(query);
        final matchesAmount = t.amount.toString().contains(query);
        return matchesNote || matchesCategory || matchesAmount;
      }).toList();
    }

    // Wrap in UI Model
    final listItems = displayedTransactions.map((tx) {
      final category = categoryProvider.getCategoryById(tx.categoryId);
      return TransactionWithCategory(category: category, transaction: tx);
    }).toList();

    // Calculate total for graph card
    final totalAmount = listItems.fold<double>(0, (sum, item) => sum + item.transaction.amount);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScreenBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // BACKGROUND CONTENT (Header, Tabs, Graph)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Row(
                      children: [

                        Text(
                          "Transactions",
                          style: GoogleFonts.manrope(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: kBlackColor.withValues(alpha: 0.9),
                            letterSpacing: -0.8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // TABS
                  Center(
                    child: Container(
                      width: 220,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: kBlackColor.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(child: _buildTabButton("Income", 0)),
                          Expanded(child: _buildTabButton("Expense", 1)),
                        ],
                      ),
                    ),
                  ),

                   // GRAPH CARD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                         gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.9),
                            const Color(0xFFDBE4F3).withValues(alpha: 0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: kBlackColor.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header inside Card
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${_selectedTabIndex == 0 ? 'Income' : 'Expense'} Trend",
                                    style: GoogleFonts.manrope(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: kBlackColor.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Total: ${formatCurrency(totalAmount, symbol: userPrefs.currencySymbol)}",
                                    style: GoogleFonts.manrope(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: kBlackColor.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                              _buildMonthDropdown(provider.getEarliestTransactionDate()),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 180,
                            child: SpaceTrendChart(
                              trend: graphData,
                              symbol: userPrefs.currencySymbol,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // DRAGGABLE SHEET
              _buildDraggableSheet(listItems),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTabIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kBlackColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? kWhiteColor : kBlackColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthDropdown(DateTime earliestDate) {
    // Generate months from earliest to now
    final now = DateTime.now();
    DateTime start = earliestDate.isAfter(now) ? now : earliestDate;
    start = DateTime(start.year, start.month);
    
    final List<DateTime> months = [];
    DateTime current = DateTime(now.year, now.month);
    
    while (current.isAfter(start) || current.isAtSameMomentAs(start)) {
      months.add(current);
      current = DateTime(current.year, current.month - 1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBlackColor.withValues(alpha: 0.05)),
      ),
      child: DropdownButton<DateTime>(
        value: _selectedMonth,
        underline: const SizedBox(),
        icon: const Icon(FluentIcons.chevron_down_24_regular, size: 16),
        isDense: true,
        dropdownColor: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        items: months.map((date) {
          final isSameYear = date.year == now.year;
          return DropdownMenuItem(
            value: date,
            child: Text(
              _formatMonth(date, showYear: !isSameYear),
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: kBlackColor.withValues(alpha: 0.8),
              ),
            ),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) setState(() => _selectedMonth = val);
        },
      ),
    );
  }

  String _formatMonth(DateTime date, {bool showYear = false}) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final month = monthNames[date.month - 1];
    if (showYear) {
      return '$month ${date.year}';
    }
    return month;
  }

  Widget _buildDraggableSheet(List<TransactionWithCategory> items) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.35,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
             // Removed gradient as asked. Solid White/Off-white for clarity
            color: kWhiteColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            
            boxShadow: [
              BoxShadow(
                color: kBlackColor.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: kBlackColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      items.isEmpty ? "No Transactions" : "${items.length} Transactions",
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: kBlackColor,
                      ),
                    ),
                    const Spacer(),
                    // Search Icon inside Sheet
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearching = !_isSearching;
                           if (!_isSearching) {
                            _searchQuery = "";
                            _searchController.clear();
                          }
                        });
                      },
                      icon: Icon(
                        _isSearching ? FluentIcons.dismiss_24_regular : FluentIcons.search_24_regular,
                        color: kBlackColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Search Bar Area
              if (_isSearching)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: kBlackColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: "Search notes, category, amount...",
                        hintStyle: GoogleFonts.manrope(color: kBlackColor.withValues(alpha: 0.4)),
                        border: InputBorder.none,
                        icon: const Icon(FluentIcons.search_24_regular, size: 20),
                      ),
                      onChanged: (val) {
                        setState(() => _searchQuery = val);
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TranscationContent(
                        transactions: items,
                        isScrollable: false,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
