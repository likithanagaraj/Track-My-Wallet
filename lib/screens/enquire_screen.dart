import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/screens/user_input_screen.dart';
import 'package:track_my_wallet_finance_app/widgets/contiuneButton.dart';
import 'package:track_my_wallet_finance_app/widgets/appScreenBackground.dart';
import 'package:track_my_wallet_finance_app/screens/homeScreen.dart';

class EnquireScreen extends StatefulWidget {
  final String currency;
  final String currencySymbol;
  
  const EnquireScreen({
    super.key,
    required this.currency,
    required this.currencySymbol,
  });

  @override
  State<EnquireScreen> createState() => _EnquireScreenState();
}

class _EnquireScreenState extends State<EnquireScreen> {
  final List<Map<String, dynamic>> options = [
    {
      'text': 'Track my spending and income automatically',
      'color': const Color(0xFFFFB088),
      'image': 'images/abstract1.png',
      'selected': false,
    },
    {
      'text': 'Achieve my financial goals and save money',
      'color': const Color(0xFFB8A4FF),
      'image': 'images/abstract2.png',
      'selected': false,
    },
    {
      'text': 'Understand where my money goes',
      'color': const Color(0xFFFF8FB8),
      'image': 'images/abstract3.png',
      'selected': false,
    },
    {
      'text': 'Gain control over my finances',
      'color': const Color(0xFF88D4FF),
      'image': 'images/abstract5.png',
      'selected': false,
    },
    {
      'text': 'Reduce debt and build wealth',
      'color': const Color(0xFFB8FF88),
      'image': 'images/abstract4.png',
      'selected': false,
    },
  ];

  void toggleOption(int index) {
    setState(() {
      options[index]['selected'] = !options[index]['selected'];
    });
  }

  bool get hasSelection => options.any((option) => option['selected'] == true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kscaffolBg,
      body: AppScreenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why do you think you need\na finance app?',
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: kBlackColor,
                    letterSpacing: -0.5,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 40),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = option['selected'] as bool;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () => toggleOption(index),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: kWhiteColor.withValues(alpha: isSelected ? 0.8 : 0.5),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected 
                                        ? kBlackColor.withValues(alpha: 0.2)
                                        : kBlackColor.withValues(alpha: 0.1),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option['text'] as String,
                                        style: GoogleFonts.manrope(
                                          fontSize: 16,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                          color: kBlackColor,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 60), // Space for the overflowing image
                                  ],
                                ),
                              ),
                              // Overflowing abstract image
                              Positioned(
                                right: -10,
                                top: -5,
                                bottom: -5,
                                child: Image.asset(
                                  option['image'] as String,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 10),
                
                ContinueButton(
                  isEnabled: hasSelection,
                  onTap: () {
                    if (hasSelection) {
                      // Collect selected purposes
                      final selectedPurposes = options
                          .where((option) => option['selected'] == true)
                          .map((option) => option['text'] as String)
                          .toList();
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserInputScreen(
                            currency: widget.currency,
                            currencySymbol: widget.currencySymbol,
                            purposes: selectedPurposes,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
