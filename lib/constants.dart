import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

// Theme colors
const kscaffolBg = Color(0xffEDEFF1);
const kScreenBgColor = Color(0xffEDEFF1);
const kEllipseColor = Color(0xffDBE4F3);
const kBlackColor = Color(0xff000100);
const kWhiteColor =Color(0xffFFFFFD);
const kCardColor = Color(0xffD9D9D9);
const kButtonColor = Color(0xff252525);
const kGreenColor = Color(0xff014E3C);
const kRedColor = Color(0xffEB4335);
const kKeyBoardCircleColor = Color(0xffF1F1F1);
const kBadgeBg = Color(0xffFFFFFD);
const kBadgeText = Color(0xff000100);
const kOrangeColor = Color(0xffEA5A1B);
const kBlueColor = Color(0xffDBE4F3);

const List<IconData> kSpaceIcons = [
  FluentIcons.airplane_24_regular,
  FluentIcons.beach_24_regular,
  FluentIcons.food_24_regular,
  FluentIcons.shopping_bag_24_regular,
  FluentIcons.vehicle_car_24_regular,
  FluentIcons.gift_24_regular,
  FluentIcons.home_24_regular,
  FluentIcons.sparkle_24_regular,
];

IconData getIconFromCodePoint(int codePoint) {
  try {
    return kSpaceIcons.firstWhere((icon) => icon.codePoint == codePoint);
  } catch (e) {
    return FluentIcons.circle_24_regular; // Default fallback
  }
}

final ktabLabelStyle = GoogleFonts.manrope(
    fontSize: 12,
    letterSpacing: -0.1,
    fontWeight: FontWeight.w500,
    height: 0,
    color: kBlackColor.withValues(alpha: 0.5)
);

final kWelcomeText =   GoogleFonts.manrope(
    fontWeight: FontWeight.w500,
    fontSize: 22,
    letterSpacing: -0.5,
    color: kBlackColor.withValues(alpha: 0.8)
);


final klabel = GoogleFonts.manrope(
    fontSize: 12,
    letterSpacing: 1,
    fontWeight: FontWeight.w500,
    height: 0,
    color: kBlackColor.withValues(alpha: 0.5)
);
