import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/screens/homeScreen.dart';
import 'package:track_my_wallet_finance_app/widgets/appScreenBackground.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScreenBgColor,
      body: AppScreenBackground(
        child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 70.0),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            Text('Welcome Back,',style: GoogleFonts.manrope(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                letterSpacing: 0
            ),),
            Column(

              children: [
                Image.asset('images/loginImage.png',),
                SizedBox(height: 30.0,),
                Column(
                  children: [
                    TextField(
                      onChanged: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: kBlackColor.withValues(alpha: 0.5)
                            )

                        ),

                      ),
                    ),
                    SizedBox(height: 24,),
                    TextField(
                      onChanged: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: kBlackColor.withValues(alpha: 0.5)
                            )

                        ),

                      ),
                    ),
                    SizedBox(height: 32,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>  HomeScreen()));
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 18.0
                        ),
                        decoration: BoxDecoration(
                            color: kBlackColor,
                            borderRadius: BorderRadiusGeometry.circular(16.0)
                        ),
                        child: Center(
                          child: Text('Continue',style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color:kWhiteColor
                          ),),
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have account?',style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor
                        ),),
                        SizedBox(width: 6,),
                        Text('Register',
                            style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                color: kBlackColor))
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ),
        ),
      ),
    );
  }
}
