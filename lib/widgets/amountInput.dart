import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';


class AmountInput extends StatelessWidget {
  final TextEditingController amountController;

  AmountInput({required this.amountController,});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: TextField(

        controller: amountController,
        readOnly: true,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.none,
        cursorColor: kBlackColor,
        cursorHeight: 40.0,
        autofocus: true,
        style: GoogleFonts.poppins(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          color: kBlackColor,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          prefixText: '₹ ',
          prefixStyle: GoogleFonts.poppins(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            color: kBlackColor,
          ),
          hintText: '0',
          hintStyle: GoogleFonts.poppins(
            fontSize: 40.0,
            fontWeight: FontWeight.w600,
            color: kBlackColor,
          ),
        ),
      ),
    );
  }
}