import 'package:flutter/material.dart';

import 'contiuneButton.dart';
import 'customNumberKeyboard.dart';


class TransactionActionsSection extends StatelessWidget {
  final Function(String) onKeyboardInput;
  final VoidCallback onContinue;
  final bool isFormValid;

  const TransactionActionsSection({
    required this.onKeyboardInput,
    required this.onContinue,
    required this.isFormValid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContinueButton(
          onTap: onContinue,
          isEnabled: isFormValid,
        ),
        const SizedBox(height: 10.0),
        CustomNumberKeyboard(onKeyboardPress:onKeyboardInput ,),
      ],
    );
  }
}