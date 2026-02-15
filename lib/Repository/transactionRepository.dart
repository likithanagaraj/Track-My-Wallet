import '../model/transactionModel.dart';
import 'package:uuid/uuid.dart';
import '../model/transaction_type.dart';

class TransactionRepository {
  final _uuid = const Uuid();

  TransactionModel create({
    required double amount,
    required TransactionType type,
    required String categoryId,
    String? note,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: _uuid.v4(), // auto-generated
      amount: amount,
      type: type,
      categoryId: categoryId,
      note: note,
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}
