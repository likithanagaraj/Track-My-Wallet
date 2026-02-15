import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'dart:math' as math;

class TranscationCard extends StatelessWidget {
  final String label;
  final String value;
  final num rotateNumber;

  TranscationCard({
    required this.label,
    required this.value,
    required this.rotateNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: kCardColor.withValues(alpha: 0.5),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  color: kBlackColor.withValues(alpha: 0.5),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.5,
                  color: kBlackColor,
                ),
              ),
            ],
          ),
          Positioned(
            top: -24,
            right: -16,
            child: Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kButtonColor,
                border: BoxBorder.all(color: kWhiteColor, width: 4),
              ),
              child: Center(
                child: Transform.rotate(
                  angle: rotateNumber * math.pi / 180,
                  child: Icon(
                    FluentIcons.arrow_down_24_regular,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
