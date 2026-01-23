import 'package:track_my_wallet_finance_app/model/transaction_type.dart';
import 'package:hive/hive.dart';
// tells Dart where generated code will go
part 'transactionModel.g.dart';


@HiveType(typeId:0 )// → tells Hive “this is a storable class”
// → assigns an index to each field
// → NEVER change these numbers later
class TransactionModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final TransactionType type;
  @HiveField(3)
  final String categoryId;
  @HiveField(4)
  final String? note;
  @HiveField(5)
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.createdAt,
    this.note,
  });
}

