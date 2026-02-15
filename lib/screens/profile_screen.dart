import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/widgets/contiuneButton.dart';
import 'package:track_my_wallet_finance_app/widgets/appScreenBackground.dart';
import 'package:track_my_wallet_finance_app/widgets/closeButton.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedCurrency = '';
  String _selectedSymbol = '';
  bool _isInitialized = false;

  final List<Map<String, String>> _currencies = [
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final prefs = context.read<UserPreferencesProvider>().preferences;
      if (prefs != null) {
        _nameController.text = prefs.userName;
        _selectedCurrency = prefs.currency;
        _selectedSymbol = prefs.currencySymbol;
        _isInitialized = true;
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty) return;

    final provider = context.read<UserPreferencesProvider>();
    await provider.updateName(_nameController.text.trim());
    await provider.updateCurrency(_selectedCurrency, _selectedSymbol);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kscaffolBg,
      body: AppScreenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Profile Settings',
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 21,
                                    letterSpacing: -0.2,
                                    color: kBlackColor
                                ),
                              ),
                              AppCloseButton(onTap: () => Navigator.pop(context)),
                            ],
                          ),
                          const SizedBox(height: 30),
                          
                          // Profile Initials Badge with Glass Effect Border
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glassy outer border
                                Container(
                                  width: 112,
                                  height: 112,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(0.5),
                                        Colors.white.withOpacity(0.05),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(color: Colors.transparent),
                                    ),
                                  ),
                                ),
                                // Main badge
                                Container(
                                  width: 95,
                                  height: 95,
                                  decoration: BoxDecoration(
                                    color: kBadgeBg,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: kBlackColor.withOpacity(0.1),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    context.watch<UserPreferencesProvider>().preferences?.initials ?? 'U',
                                    style: GoogleFonts.manrope(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                      color: kBadgeText,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          Text(
                            'Name',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: kBlackColor.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Theme(
                             data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                cursorColor: kBlackColor,
                                selectionHandleColor: kBlackColor,
                                selectionColor: kBlackColor.withOpacity(0.1),
                              ),
                            ),
                            child: TextField(
                              controller: _nameController,
                              cursorColor: kBlackColor,
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: kWhiteColor.withOpacity(0.5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          Text(
                            'Primary Currency',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: kBlackColor.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: kWhiteColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                 dropdownColor: kWhiteColor,
                                borderRadius: BorderRadius.circular(20),
                                value: _selectedCurrency,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kBlackColor),
                                items: _currencies.map((currency) {
                                  return DropdownMenuItem<String>(
                                    value: currency['name'],
                                    child: Text(
                                      '${currency['symbol']} ${currency['name']}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onTap: () {
                                      _selectedSymbol = currency['symbol']!;
                                    },
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCurrency = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          
                          const Spacer(),
                          const SizedBox(height: 20),
                          
                          ContinueButton(
                            isEnabled: _nameController.text.isNotEmpty,
                            onTap: _saveChanges,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
