import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';

class ThoughtsTile extends StatelessWidget {
  final String text;
  final double radiusRight;
  final double radiusLeft;
  const ThoughtsTile({required this.text, required this.radiusLeft,required this.radiusRight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadiusGeometry.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
          bottomLeft: Radius.circular(radiusLeft),
          bottomRight: Radius.circular(radiusRight)
        ),
        border: Border.all(
          width: 0.6,
          color: kBlackColor.withValues(alpha: 0.5),
        )
      ),
      child: Text(text,style: GoogleFonts.manrope(
        fontSize: 12.0,
        color: kBlackColor,
        fontWeight: FontWeight.w500,
        letterSpacing: 0
      ),),
    );
  }
}
