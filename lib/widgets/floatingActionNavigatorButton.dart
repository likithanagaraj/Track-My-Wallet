import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants.dart';
import '../screens/transcationScreen.dart';

class FloatingActionNavigatorButton extends StatelessWidget {
  final VoidCallback onTap;
  const FloatingActionNavigatorButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  FloatingActionButton(
      elevation: 0,
      backgroundColor: kButtonColor,
      onPressed:onTap,
      child: FaIcon(FontAwesomeIcons.plus),
    );
  }
}
