import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';


class AmountInput extends StatelessWidget {
  final TextEditingController amountController;
  final FocusNode amountFocusNode;

  AmountInput({required this.amountController,required this.amountFocusNode});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6.0,
      children: [
        Text('₹',style: GoogleFonts.manrope(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: kBlackColor,
        ),),
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
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              focusNode: amountFocusNode,
              cursorColor: kBlackColor,
              cursorHeight: 40.0,
              style: GoogleFonts.manrope(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: kBlackColor,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: '0',
                hintStyle: GoogleFonts.manrope(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w600,
                  color: kBlackColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}