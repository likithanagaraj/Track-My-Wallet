import 'package:flutter/cupertino.dart';
import 'package:track_my_wallet_finance_app/model/transaction_type.dart';

class CategoryModel {
  final String id;
  final String categoryLabel;
  final IconData categoryIcon;
  final TransactionType type; // income or expense

  CategoryModel({
    required this.categoryLabel,
    required this.id,
    required this.categoryIcon,
    required this.type,
  });
}
