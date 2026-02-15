import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_repository.dart';
import 'package:track_my_wallet_finance_app/screens/enquire_screen.dart';
import 'package:track_my_wallet_finance_app/widgets/contiuneButton.dart';
import 'package:track_my_wallet_finance_app/widgets/appScreenBackground.dart';
import 'package:track_my_wallet_finance_app/screens/user_input_screen.dart';

class CurrencySelectionScreen extends StatefulWidget {
  const CurrencySelectionScreen({super.key});

  @override
  State<CurrencySelectionScreen> createState() =>
      _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  final List<Map<String, String>> currencies = [
    {'symbol': '\$', 'name': 'US Dollar'},
    {'symbol': '€', 'name': 'Euro'},
    {'symbol': '£', 'name': 'British Pound'},
    {'symbol': '₹', 'name': 'Indian Rupee'},
    {'symbol': '¥', 'name': 'Japanese Yen'},
    {'symbol': '¥', 'name': 'Chinese Yuan'},
    {'symbol': 'A\$', 'name': 'Australian Dollar'},
    {'symbol': 'C\$', 'name': 'Canadian Dollar'},
    {'symbol': 'CHF', 'name': 'Swiss Franc'},
    {'symbol': '₩', 'name': 'Korean Won'},
    {'symbol': 'R\$', 'name': 'Brazilian Real'},
    {'symbol': '₽', 'name': 'Russian Ruble'},
    {'symbol': 'د.إ', 'name': 'UAE Dirham'},
    {'symbol': '₫', 'name': 'Vietnamese Dong'},
  ];

  int selectedIndex = 3; // Default to Indian Rupee
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 3);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kscaffolBg,
      body: AppScreenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 26.0,
              vertical: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Currency',
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: kBlackColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 60),

                Expanded(
                  child: Center(
                    child: SizedBox(
                      height: 400,
                      child: ListWheelScrollView.useDelegate(
                        controller: _scrollController,
                        itemExtent: 80,
                        diameterRatio: 1.5,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: currencies.length,
                          builder: (context, index) {
                            final isSelected = index == selectedIndex;
                            final currency = currencies[index];

                            return Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: GoogleFonts.manrope(
                                  fontSize: isSelected ? 36 : 30,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: kBlackColor.withValues(
                                    alpha: isSelected ? 1.0 : 0.2,
                                  ),
                                  letterSpacing: -1,
                                ),
                                child: Transform.scale(
                                  scale: isSelected ? 1.1 : 1.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(currency['symbol']!, maxLines: 1),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          currency['name']!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                ContinueButton(
                  isEnabled: true,
                  onTap: () {
                    final selectedCurrency = currencies[selectedIndex];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnquireScreen(
                          currency: selectedCurrency['name']!,
                          currencySymbol: selectedCurrency['symbol']!,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
