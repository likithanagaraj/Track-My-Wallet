// import 'package:flutter/material.dart';
// import 'package:track_my_wallet_finance_app/widgets/typeChip.dart';
//
// import '../model/transactionModel.dart';
// import '../model/transaction_type.dart';
//
//
// class TypeChips extends StatelessWidget {
//   final String selectedType;
//   final ValueChanged<String> onTypeChanged;
//
//   const TypeChips({required this.selectedType, required this.onTypeChanged});
//
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 10,
//       children: [TransactionType.income, TransactionType.expense]
//           .map((type) => TypeChip(
//         type: type,
//         isSelected: selectedType == type,
//         onSelected: () => onTypeChanged(type),
//       ))
//           .toList(),
//     );
//   }
// }
//
//
//
