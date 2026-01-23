import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';

class KeyboardNumbers extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const KeyboardNumbers({required this.label,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: kKeyBoardCircleColor,
        child: Text(label,style: GoogleFonts.inter(
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: kButtonColor
        ),),
      ),
    );
  }
}
