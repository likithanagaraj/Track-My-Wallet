import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          child: FaIcon(
            hasCategory ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.tag,
            size: 14,
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }
}