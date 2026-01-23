import 'package:track_my_wallet_finance_app/model/categoryModel.dart';
import 'package:track_my_wallet_finance_app/model/transactionModel.dart';

class TransactionWithCategory {
  final TransactionModel transaction;
  final CategoryModel category;
  TransactionWithCategory({required this.category,required this.transaction});

}