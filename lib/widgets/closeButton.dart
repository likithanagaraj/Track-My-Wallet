import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../constants.dart';

class AppCloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const AppCloseButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: IconButton(
        padding: const EdgeInsets.all(12), // Larger hit area
        onPressed: onTap,
        icon: const Icon(
          FluentIcons.dismiss_24_filled,
          color: kBlackColor,
          size: 24,
        ),
      ),
    );
  }
}
