import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../constants.dart';

class CategoryButton extends StatelessWidget {
  final bool hasCategory;
  final VoidCallback onTap;

  const CategoryButton({
    required this.onTap,
    required this.hasCategory,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: CircleAvatar(
          radius: 16.0,
          backgroundColor: kButtonColor,
          child: Icon(
            hasCategory ? FluentIcons.checkmark_circle_24_filled : FluentIcons.tag_24_filled,
            size: 16,
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }
}