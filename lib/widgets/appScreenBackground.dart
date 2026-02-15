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
          // 1. DBE4F3 ellipse (bottom layer) with drop shadow (X: -2, Y: 17, Blur: 15)
          Positioned(
            top: 0,
            left: -20,
            right: -20,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 15),
              child: Container(
                width: w + 40,
                height: 240,
                decoration: BoxDecoration(
                  color: kEllipseColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.elliptical(300, 200),
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: kEllipseColor.withValues(alpha: 0.6),
                  //     offset: const Offset(-2, 20),
                  //     blurRadius: 2,
                  //     spreadRadius: 8,
                  //   ),
                  // ],
                ),
              ),
            ),
          ),
          // 2. White circle (top layer) - layer blur 4, FFFFFF 40%
          Positioned(
            top: -80,
            left: w / 2 - 120,
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
          ),
          child,
        ],
      ),
    );
  }
}
