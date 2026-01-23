import 'package:flutter/material.dart';
import 'package:track_my_wallet_finance_app/model/transaction_type.dart';
import 'package:track_my_wallet_finance_app/widgets/typeChip.dart';
import 'amountInput.dart';
import 'noteAndCategory.dart';

class TransactionInputSection extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController noteController;
  final TransactionType selectedType;
  final bool hasCategorySelected;
  final ValueChanged<TransactionType> onTypeChanged;
  final VoidCallback onCategoryTap;
  final FocusNode? noteFocusNode;

  const TransactionInputSection({
    required this.amountController,
    required this.noteController,
    required this.selectedType,
    required this.hasCategorySelected,
    required this.onTypeChanged,
    required this.onCategoryTap,
    required this.noteFocusNode
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AmountInput(amountController: amountController),

        NoteAndCategoryRow(
          noteFocusNode: noteFocusNode,
          onCategoryTap: onCategoryTap,
          noteController: noteController,
          hasCategorySelected: hasCategorySelected,
        ),
        const SizedBox(height: 10.0),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: TransactionType.values.map((type) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: TypeChip(
                type: type,
                isSelected: selectedType == type,
                onSelected: () => onTypeChanged(type),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}