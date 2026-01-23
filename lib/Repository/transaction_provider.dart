import 'package:flutter/material.dart';
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
