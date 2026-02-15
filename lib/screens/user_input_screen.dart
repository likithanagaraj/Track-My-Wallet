import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_repository.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_provider.dart';
import 'package:track_my_wallet_finance_app/model/user_preferences.dart';
import 'package:track_my_wallet_finance_app/screens/homeScreen.dart';
import 'package:track_my_wallet_finance_app/widgets/contiuneButton.dart';
import 'package:track_my_wallet_finance_app/widgets/appScreenBackground.dart';

class UserInputScreen extends StatefulWidget {
  final String currency;
  final String currencySymbol;
  final List<String> purposes;
  
  const UserInputScreen({
    super.key,
    required this.currency,
    required this.currencySymbol,
    required this.purposes,
  });

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final UserPreferencesRepository _userPrefsRepo = UserPreferencesRepository();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    if (_nameController.text.trim().isEmpty) return;
    
    setState(() {
      _isSaving = true;
    });

    try {
      // Create user preferences object
      final userPrefs = UserPreferences(
        userName: _nameController.text.trim(),
        currency: widget.currency,
        currencySymbol: widget.currencySymbol,
        appPurposes: widget.purposes,
        isOnboardingComplete: true,
      );

      // Save to Hive
      await _userPrefsRepo.saveUserPreferences(userPrefs);

      if (mounted) {
        // Refresh provider data for immediate update in Home
        await context.read<UserPreferencesProvider>().loadPreferences();
        
        // Navigate to Home and remove all previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

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
                  'Enter your name:',
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: kBlackColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 40),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: kWhiteColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: kBlackColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: kBlackColor,
                        selectionHandleColor: kBlackColor, // This changes the drop handle
                        selectionColor: kBlackColor.withOpacity(0.1), // Optional: selection highlight
                      ),
                    ),
                    child: TextField(
                      autofocus: true,
                      controller: _nameController,
                      cursorColor: kBlackColor,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        color: kBlackColor,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter your name",
                        hintStyle: GoogleFonts.manrope(
                          color: kBlackColor.withValues(alpha: 0.3),
                          fontSize: 16,
                          letterSpacing: -0.2,
                          fontWeight: FontWeight.w500,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kBlueColor),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kBlueColor, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                
                const Spacer(),
                
                ContinueButton(
                  isEnabled: _nameController.text.trim().isNotEmpty && !_isSaving,
                  onTap: _saveAndContinue,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
