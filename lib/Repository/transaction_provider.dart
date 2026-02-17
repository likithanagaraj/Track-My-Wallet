import 'package:flutter/material.dart';
import 'package:track_my_wallet_finance_app/data/categories.dart';
import 'package:track_my_wallet_finance_app/model/categoryModel.dart';
import 'package:track_my_wallet_finance_app/model/transactionModel.dart';
import 'package:track_my_wallet_finance_app/model/transaction_type.dart';
import 'package:hive/hive.dart';
class TransactionProvider extends ChangeNotifier {
  final List<TransactionModel> _transactions = [];
  bool isLoaded = false;

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  void addTransaction(TransactionModel transaction) {
    final box = Hive.box<TransactionModel>('transactions');
    box.put(transaction.id, transaction);
    loadFromHive();
  }

  void updateTransaction(TransactionModel transaction) {
    final box = Hive.box<TransactionModel>('transactions');
    box.put(transaction.id, transaction);
    loadFromHive();
  }

  void deleteTransaction(String id) {
    final box = Hive.box<TransactionModel>('transactions');
    box.delete(id);
    loadFromHive();
  }

  List<TransactionModel> getFilteredTransactions(String period) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    
    switch (period) {
      case 'Today':
        return _transactions.where((t) => t.createdAt.isAfter(startOfToday.subtract(const Duration(seconds: 1)))).toList();
      case 'This Week':
        final weekStart = startOfToday.subtract(Duration(days: now.weekday - 1));
        return _transactions.where((t) => t.createdAt.isAfter(weekStart.subtract(const Duration(seconds: 1)))).toList();
      case 'This Month':
        final monthStart = DateTime(now.year, now.month, 1);
        return _transactions.where((t) => t.createdAt.isAfter(monthStart.subtract(const Duration(seconds: 1)))).toList();
      default:
        return _transactions;
    }
  }

  List<TransactionModel> getFilteredByDate(DateTime date) {
    return _transactions.where((t) {
      return t.createdAt.year == date.year &&
             t.createdAt.month == date.month &&
             t.createdAt.day == date.day;
    }).toList();
  }

  double getIncome({String period = 'All Time', DateTime? date}) {
    final filtered = date != null 
        ? getFilteredByDate(date) 
        : (period == 'All Time' ? _transactions : getFilteredTransactions(period));
    return filtered
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getExpense({String period = 'All Time', DateTime? date}) {
    final filtered = date != null 
        ? getFilteredByDate(date) 
        : (period == 'All Time' ? _transactions : getFilteredTransactions(period));
    return filtered
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  List<({String id, String label, double amount, IconData icon})>
  getTopExpenseCategories({String period = 'All Time', DateTime? date}) {
    final filtered = date != null 
        ? getFilteredByDate(date) 
        : (period == 'All Time' ? _transactions : getFilteredTransactions(period));
    final expenses = filtered
        .where((t) => t.type == TransactionType.expense)
        .toList();

    final byCategory = <String, double>{};

    for (final t in expenses) {
      byCategory[t.categoryId] =
          (byCategory[t.categoryId] ?? 0) + t.amount;
    }

    final list = byCategory.entries.map((e) {
      final category = expenseCategories.firstWhere(
        (c) => c.id == e.key,
        orElse: () => CategoryModel(
          id: e.key,
          categoryLabel: e.key,
          categoryIcon: Icons.help_outline,
          type: TransactionType.expense,
        ),
      );

      return (
        id: e.key,
        label: category.categoryLabel,
        amount: e.value,
        icon: category.categoryIcon,
      );
    }).toList();

    list.sort((a, b) => b.amount.compareTo(a.amount));
    return list;
  }

  List<({DateTime date, double amount})> getSpaceTrend(String eventId) {
    final spaceTransactions = _transactions.where((t) => t.eventId == eventId && t.type == TransactionType.expense).toList();
    if (spaceTransactions.isEmpty) return [];

    // Group by day
    final Map<DateTime, double> dailyMap = {};
    for (var t in spaceTransactions) {
      final date = DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day);
      dailyMap[date] = (dailyMap[date] ?? 0) + t.amount;
    }

    final sortedDates = dailyMap.keys.toList()..sort();
    return sortedDates.map((d) => (date: d, amount: dailyMap[d]!)).toList();
  }

  List<({DateTime date, double income, double expense})> getDailyStats() {
    final now = DateTime.now();
    // Use last 7 days as "Daily" view
    final days = List.generate(7, (i) => DateTime(now.year, now.month, now.day).subtract(Duration(days: i))).reversed.toList();
    
    return days.map((dateTime) {
      final dayTransactions = _transactions.where((t) {
        return t.createdAt.year == dateTime.year &&
               t.createdAt.month == dateTime.month &&
               t.createdAt.day == dateTime.day;
      });

      double dailyIncome = dayTransactions
          .where((t) => t.type == TransactionType.income)
          .fold(0, (sum, t) => sum + t.amount);
          
      double dailyExpense = dayTransactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0, (sum, t) => sum + t.amount);

      return (date: dateTime, income: dailyIncome, expense: dailyExpense);
    }).toList();
  }

  List<({DateTime date, double income, double expense})> getWeeklyStats() {
    final now = DateTime.now();
    // Show last 4 weeks
    final weeks = List.generate(4, (i) => DateTime(now.year, now.month, now.day).subtract(Duration(days: i * 7))).reversed.toList();
    
    return weeks.map((dateTime) {
      final weekStart = dateTime.subtract(Duration(days: dateTime.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6, hours: 23, minutes: 59));

      final weekTransactions = _transactions.where((t) => t.createdAt.isAfter(weekStart.subtract(const Duration(seconds: 1))) && t.createdAt.isBefore(weekEnd.add(const Duration(seconds: 1))));

      double income = weekTransactions
          .where((t) => t.type == TransactionType.income)
          .fold(0, (sum, t) => sum + t.amount);
          
      double expense = weekTransactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0, (sum, t) => sum + t.amount);

      return (date: weekStart, income: income, expense: expense);
    }).toList();
  }

  List<({DateTime date, double income, double expense})> getMonthlyStats() {
    final now = DateTime.now();
    // Last 6 months
    final months = List.generate(6, (i) => DateTime(now.year, now.month - i, 1)).reversed.toList();
    
    return months.map((monthDate) {
      final monthTransactions = _transactions.where((t) => t.createdAt.year == monthDate.year && t.createdAt.month == monthDate.month);

      double income = monthTransactions
          .where((t) => t.type == TransactionType.income)
          .fold(0, (sum, t) => sum + t.amount);
          
      double expense = monthTransactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0, (sum, t) => sum + t.amount);

      return (date: monthDate, income: income, expense: expense);
    }).toList();
  }

  /// Returns daily totals for a specific month and type (income/expense)
  /// If type is null, returns both separate (though currently we typically want one specific line)
  List<({DateTime date, double amount})> getMonthlyDailyStats(DateTime month, TransactionType type) {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    
    final dailyStats = <DateTime, double>{};
    
    // Initialize all days with 0
    for(int i=0; i<daysInMonth; i++) {
      final d = DateTime(month.year, month.month, i+1);
      // Don't include future days
      if (d.isAfter(DateTime.now())) break;
      dailyStats[d] = 0.0;
    }

    final monthTransactions = _transactions.where((t) {
      return t.createdAt.year == month.year && 
             t.createdAt.month == month.month &&
             t.type == type;
    });

    for (var t in monthTransactions) {
      final date = DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day);
      dailyStats[date] = (dailyStats[date] ?? 0) + t.amount;
    }

    final sortedDates = dailyStats.keys.toList()..sort();
    return sortedDates.map((d) => (date: d, amount: dailyStats[d]!)).toList();
  }

  DateTime getEarliestTransactionDate() {
    if (_transactions.isEmpty) return DateTime.now();
    return _transactions.map((t) => t.createdAt).reduce((a, b) => a.isBefore(b) ? a : b);
  }


  void loadFromHive(){
    final box = Hive.box<TransactionModel>('transactions');
    // box.values → returns Iterable<TransactionModel>
    // so to make it List -> add a method .toList()
    _transactions.clear();
    _transactions.addAll(box.values.toList()..sort((a,b)=>b.createdAt.compareTo(a.createdAt)));
    isLoaded = true;
    notifyListeners();

    debugPrint('Loaded ${_transactions.length} transactions from Hive');

  }

  TransactionProvider(){
    loadFromHive();
  }

}
