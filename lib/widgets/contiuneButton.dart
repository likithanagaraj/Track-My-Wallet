import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';


class ContinueButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isEnabled;
  final String text; // Added text parameter

  const ContinueButton({
    super.key, 
    required this.onTap,
    required this.isEnabled,
    this.text = 'Continue', // Default value
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: isEnabled ? kButtonColor : kButtonColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: kWhiteColor,
            ),
          ),
        ),
      ),
    );
  }
}