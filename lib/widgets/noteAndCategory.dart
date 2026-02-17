import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import 'categoryButton.dart';


class NoteAndCategoryRow extends StatelessWidget {
  final TextEditingController noteController;
  final VoidCallback onCategoryTap;
  final bool hasCategorySelected;
  final FocusNode? noteFocusNode;

  const NoteAndCategoryRow({
    required this.noteController,
    required this.onCategoryTap,
    required this.noteFocusNode,
    required this.hasCategorySelected
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IntrinsicWidth(
          child: Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: kBlackColor,
                selectionHandleColor: kBlackColor,
                selectionColor: kBlackColor.withValues(alpha: 0.1),
              ),
            ),
            child: TextField(
              focusNode: noteFocusNode,
              controller: noteController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              style: GoogleFonts.manrope(fontSize: 12.0, letterSpacing: -0.2),
              decoration: const InputDecoration(
                hintText: 'Add note',
                border: InputBorder.none,
                isDense: true,

              ),
            ),
          ),
        ),
        const SizedBox(width: 6.0),
        CategoryButton(
          hasCategory: hasCategorySelected,
          onTap:  onCategoryTap,
        ),
      ],
    );
  }
}