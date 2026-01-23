import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';


class ContinueButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isEnabled;
  const ContinueButton({required this.onTap,required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: isEnabled ? kButtonColor : kButtonColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            'Continue',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: kWhiteColor,
            ),
          ),
        ),
      ),
    );
  }
}