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

  double getIncome() {
    var a = _transactions.where(
      (income) => income.type == TransactionType.income,
    );
    var b = a.map((e) => e.amount);
    double res = b.fold(0, (prev, curr) => prev + curr);
    return res;
  }


  double getExpense() {
    var a = _transactions.where(
          (income) => income.type == TransactionType.expense,
    );
    var b = a.map((e) => e.amount);
    double res = b.fold(0, (prev, curr) => prev + curr);
    return res;
  }

  List<({String id, String label, double amount, IconData icon})>
  getTopExpenseCategories() {

    final expenses = _transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();

    final byCategory = <String, double>{};

    for (final t in expenses) {
      byCategory[t.categoryId] =
          (byCategory[t.categoryId] ?? 0) + t.amount;
    }

    debugPrint('Category map: $byCategory');

    final list = byCategory.entries.map((e) {
      final category = expenseCategories
          .firstWhere(
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

  List<({DateTime date, double income, double expense})> getWeeklyStats() {
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) => DateTime(now.year, now.month, now.day).subtract(Duration(days: i))).reversed.toList();
    
    return last7Days.map((dateTime) {
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
