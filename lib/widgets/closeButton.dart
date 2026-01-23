import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class CloseButtonIcon extends StatelessWidget {
  final VoidCallback onTap;

  const CloseButtonIcon({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: const FaIcon(FontAwesomeIcons.close, color: kBlackColor, size: 18),
      ),
    );
  }
}