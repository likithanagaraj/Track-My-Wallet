import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/Repository/transaction_provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/screens/homeScreen.dart';
import 'package:track_my_wallet_finance_app/widgets/thoughts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _navigated) return;

      final isLoaded =
          context.read<TransactionProvider>().isLoaded;

      if (isLoaded) {
        _navigated = true;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 70.0),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;

                      return Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'images/confusedImage.png',
                              height: h * 0.55,
                            ),
                          ),

                          Align(
                            alignment: Alignment.topCenter,
                            child: ThoughtsTile(text: 'balance',radiusLeft: 0,radiusRight: 50,),
                          ),

                          Positioned(
                            left: 10,
                            top: h * 0.15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                ThoughtsTile(text: 'income',radiusLeft: 50,radiusRight: 0,),
                                SizedBox(height: 8),
                                ThoughtsTile(text: 'fun',radiusLeft: 50,radiusRight: 0,),
                                SizedBox(height: 8),
                                ThoughtsTile(text: 'retire',radiusLeft: 50,radiusRight: 0,),
                              ],
                            ),
                          ),

                          Positioned(
                            right: 10,
                            top: h * 0.15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                ThoughtsTile(text: 'expenses',radiusLeft: 0,radiusRight: 50,),
                                SizedBox(height: 8),
                                ThoughtsTile(text: 'food',radiusLeft: 0,radiusRight: 50,),
                                SizedBox(height: 8),
                                ThoughtsTile(text: 'travel',radiusLeft: 0,radiusRight: 50,),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                SizedBox(height: 30.0),
                // Content
                Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'Track My Wallet',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        letterSpacing: -1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      'your minimal and mindful budgeting app',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w500,
                        color: kBlackColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Button
            // GestureDetector(
            //   onTap: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
            //   },
            //   child: Container(
            //     width: double.infinity,
            //     padding: EdgeInsets.symmetric(
            //       horizontal: 6.0,
            //       vertical: 18.0
            //     ),
            //     decoration: BoxDecoration(
            //       color: kBlackColor,
            //       borderRadius: BorderRadiusGeometry.circular(16.0)
            //     ),
            //     child: Center(
            //       child: Text('Continue',style: GoogleFonts.poppins(
            //         fontWeight: FontWeight.w600,
            //         fontSize: 22,
            //         color:kWhiteColor
            //       ),),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
