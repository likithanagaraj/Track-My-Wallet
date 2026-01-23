import 'package:flutter/material.dart';
import 'package:track_my_wallet_finance_app/widgets/keyboardNumbers.dart';

class CustomNumberKeyboard extends StatelessWidget {
  final Function(String) onKeyboardPress;

  CustomNumberKeyboard({required this.onKeyboardPress});
  final List<List<String>> keyboardLayout = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['.', '0', '⌫'],
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: keyboardLayout.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              return KeyboardNumbers(
                label: key,
                onTap:()=>onKeyboardPress(key)
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}


