

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/model/transaction_type.dart';

import '../constants.dart';


class TypeChip extends StatelessWidget {
  final TransactionType type;
  final bool isSelected;
  final VoidCallback onSelected;

  const TypeChip({
    required this.type,
    required this.isSelected,
    required this.onSelected,
  });

  String get label {
    switch (type) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      padding: const EdgeInsets.all(2.0),
      selectedColor: kGreenColor,
      avatar: CircleAvatar(
        backgroundColor:  isSelected ? kWhiteColor :kCardColor,
        child: Transform.rotate(
          angle: type == TransactionType.expense ? 135 * math.pi / 180 : -45 * math.pi / 180,
          child: FaIcon(
            FontAwesomeIcons.arrowLeft,
            size: 12,
            color: isSelected ? kBlackColor : kBlackColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      backgroundColor: kWhiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      showCheckmark: false,
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: isSelected ? kWhiteColor : kBlackColor.withValues(alpha: 0.5),
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (_)=>onSelected(),
    );
  }
}