import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class EmptyTransactionsWidget extends StatelessWidget {
  final VoidCallback onAddTap;
  
  const EmptyTransactionsWidget({super.key, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: GestureDetector(
              onTap: onAddTap,
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kWhiteColor.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        FluentIcons.receipt_add_24_regular,
                        size: 34,
                        color: Colors.black26,
                      ),
                    ),
                    Text(
                      'No transactions yet',
                      style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: kBlackColor.withValues(alpha: 0.4),
                        letterSpacing: -0.2
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text(
                    //   'Tap anywhere to add your first record',
                    //   style: GoogleFonts.manrope(
                    //     fontSize: 13,
                    //     fontWeight: FontWeight.w500,
                    //     color: kBlackColor.withValues(alpha: 0.3),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
