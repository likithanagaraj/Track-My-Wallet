import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/screens/transcationScreen.dart';
import 'package:track_my_wallet_finance_app/widgets/custom_bottom_bar.dart';
import 'package:track_my_wallet_finance_app/widgets/incomeExpenseSummaryCard.dart';
import 'package:track_my_wallet_finance_app/widgets/dynamicTab.dart';
import 'package:track_my_wallet_finance_app/widgets/route_animations.dart';
import 'package:home_widget/home_widget.dart';
import 'package:track_my_wallet_finance_app/screens/AllTransactionsScreen.dart';
import 'package:track_my_wallet_finance_app/screens/learn_screen.dart';
import 'package:track_my_wallet_finance_app/screens/profile_screen.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_provider.dart';
import 'package:track_my_wallet_finance_app/widgets/spaces_carousel.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _updateHomeWidget();
  }

  Future<void> _updateHomeWidget() async {
    await HomeWidget.saveWidgetData(
      'widget_text',
      "Welcome to PaisaLogr",
    );

    await HomeWidget.updateWidget(
      name: 'AppWidgetDemo',
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      SmoothPageRoute(page: const ProfileScreen()),
    );
  }

  void openAddTransaction() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).push(SmoothPageRoute(page: const TransactionScreen()));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userPrefs = context.watch<UserPreferencesProvider>();
    final userName = userPrefs.userName;
    final initials = userPrefs.preferences?.initials ?? 'U';

    Widget body;
    if (_selectedIndex == 0) {
      body = _buildHomeContent(userName, initials);
    } else if (_selectedIndex == 1) {
      body = const AllTransactionsScreen();
    } else if (_selectedIndex == 3) {
      body = const ProfileScreen();
    } else {
      body = const Center(child: Text("Page Coming Soon"));
    }

    return Scaffold(
      backgroundColor: kScreenBgColor,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        onAddTap: openAddTransaction,
      ),
      body: body,
    );
  }

  Widget _buildHomeContent(String userName, String initials) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 14.0,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hi,$userName', style: kWelcomeText),
                GestureDetector(
                  onTap: _openProfile,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glassy border for small badge
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.6),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.2,
                          ),
                        ),
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                      ),
                      // Badge
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: kBadgeBg,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          initials,
                          style: GoogleFonts.manrope(
                            color: kBadgeText,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height :195,child: IncomeExpenseSummaryCard()),
            
            Expanded(
              child: Column(
                spacing: 4.0,
                children: [
                  const SpacesCarousel(),

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: kBlueColor,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: kBlackColor.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],

                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 14),
                      child: Column(
                        spacing: 4,
                        children: [
                          Expanded(
                            child: DynamicTab(
                              limitToLatestGroup: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
