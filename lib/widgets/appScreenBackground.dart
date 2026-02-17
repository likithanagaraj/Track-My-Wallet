import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:track_my_wallet_finance_app/constants.dart';

/// Background for screens other than Home: EDEFF1 base, DBE4F3 ellipse with
/// drop shadow, and white blur circle (40% opacity, blur 4) on top.
class AppScreenBackground extends StatelessWidget {
  final Widget child;

  const AppScreenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: kScreenBgColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          buildEllipse(context, w),
          buildWhiteCircle(context, w),
          child,
        ],
      ),
    );
  }

  static Widget buildEllipse(BuildContext context, double width) {
    return Positioned(
      top: 0,
      left: -20,
      right: -20,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 15),
        child: Container(
          width: width + 40,
          height: 240,
          decoration: const BoxDecoration(
            color: kEllipseColor,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(300, 200),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildWhiteCircle(BuildContext context, double width) {
    return Positioned(
      top: -80,
      left: width / 2 - 120,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 15),
        child: Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kWhiteColor.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
