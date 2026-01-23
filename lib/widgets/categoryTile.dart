import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/model/categoryModel.dart';

import '../constants.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onSelect;

  const CategoryTile({
    required this.category,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      activeColor: kBlackColor,

      value: category.categoryLabel,
      groupValue: isSelected ? category.categoryLabel : null,
      onChanged: (_) => onSelect(),
      controlAffinity: ListTileControlAffinity.trailing,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: kGreenColor.withValues(alpha: 0.1),
            radius: 17,
            child: FaIcon(
              category.categoryIcon,
              size: 16,
              color: kBlackColor.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            category.categoryLabel,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: -0.2,
              color: isSelected ? kBlackColor : kBlackColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}