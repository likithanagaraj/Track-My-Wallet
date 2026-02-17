import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/widgets/appScreenBackground.dart';
import 'package:track_my_wallet_finance_app/widgets/closeButton.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  final List<Map<String, String>> _tips = [
    {
      'title': 'The 50/30/20 Rule',
      'description': 'Allocate 50% of your income to needs, 30% to wants, and 20% to savings and debt repayment. This simple ratio helps maintain a balanced lifestyle while building wealth.',
      'icon': 'images/learn1.png',
      'color': '0xFFFFB088',
    },
    {
      'title': 'Emergency Fund',
      'description': 'Aim to save 3 to 6 months of basic living expenses. This fund acts as a safety net for unexpected events like medical emergencies or job loss, preventing you from falling into debt.',
      'icon': 'images/learn2.png',
      'color': '0xFFB8A4FF',
    },
    {
      'title': 'Power of Compounding',
      'description': 'The earlier you start investing, the more your money grows. Compounding is earning interest on interest, which can turn small monthly contributions into significant wealth over time.',
      'icon': 'images/learn3.png',
      'color': '0xFFFF8FB8',
    },
    {
      'title': 'Avoid Lifestyle Creep',
      'description': 'As your income increases, resist the urge to increase your spending at the same rate. Keep your expenses stable and direct your raises toward investments and debt reduction.',
      'icon': 'images/learn5.png',
      'color': '0xFF88D4FF',
    },
    {
      'title': 'Track Every Cent',
      'description': 'Knowing exactly where your money goes is the first step to financial freedom. Small daily spends like coffee or snacks can add up to hundreds of dollars every month.',
      'icon': 'images/learn4.png',
      'color': '0xFFB8FF88',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kscaffolBg,
      body: AppScreenBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Financial Education',
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Text(
                  'Swipe through these tips to improve your financial health and reach your goals faster.',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: kBlackColor.withValues(alpha: 0.5),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _tips.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final tip = _tips[index];
                    final double scale = index == _currentPage ? 1.0 : 0.9;
                    
                    final screenHeight = MediaQuery.of(context).size.height;
                    final cardHeight = screenHeight * 0.58; 
                    
                    return Transform.scale(
                      scale: scale,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: cardHeight,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(int.parse(tip['color']!)).withValues(alpha: 0.9),
                                  Color(int.parse(tip['color']!)).withValues(alpha: 0.6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(int.parse(tip['color']!)).withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                  spreadRadius: 2,
                                ),
                              ],
                              border: Border.all(
                                color: kWhiteColor.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            constraints: const BoxConstraints(maxHeight: 220),
                                            decoration: BoxDecoration(
                                              color: kWhiteColor.withValues(alpha: 0.2),
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(20)
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            child: Image.asset(
                                              tip['icon']!,
                                              fit: BoxFit.contain,
                                            )
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            tip['title']!,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.manrope(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              color: kBlackColor,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            tip['description']!,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.manrope(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: kBlackColor.withValues(alpha: 0.7),
                                              letterSpacing: 0,
                                              height: 1.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_tips.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? kBlackColor : kBlackColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
