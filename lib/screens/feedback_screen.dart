import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/widgets/appScreenBackground.dart';
import 'package:track_my_wallet_finance_app/widgets/contiuneButton.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../Repository/user_preferences_provider.dart';
import 'dart:io' show Platform;
import 'package:package_info_plus/package_info_plus.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isLoading = false;

  // TODO: Replace with your actual EmailJS keys
  final String _serviceId = 'service_6mdo7c8';
  final String _templateId = 'template_idr6cyt';
  final String _userId = 'LX1yzkRCW_opDQmOu';

  Future<void> _sendFeedback() async {
    if (_feedbackController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userPrefs = context.read<UserPreferencesProvider>();
      final userName = userPrefs.preferences?.userName ?? 'Annonymous User';
      
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appVersion = "${packageInfo.version} (${packageInfo.buildNumber})";
      String os = "${Platform.operatingSystem} ${Platform.operatingSystemVersion}";
      String timestamp = DateTime.now().toString();

      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      
      final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _userId,
          'template_params': {
            'message': _feedbackController.text,
            'user_name': userName,
            'app_version': appVersion,
            'os': os,
            'timestamp': timestamp,
          }
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Feedback sent successfully!',
                style: GoogleFonts.manrope(),
              ),
              backgroundColor: kGreenColor,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        debugPrint('EmailJS Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to send feedback: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error sending feedback: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to send feedback. Please try again.',
              style: GoogleFonts.manrope(),
            ),
            backgroundColor: kRedColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppScreenBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(FluentIcons.chevron_left_24_regular, color: kBlackColor),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "Feedback",
                                style: GoogleFonts.manrope(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: kBlackColor,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                    
                          // Logo
                          Center(
                            child: Image.asset(
                              'images/logo.png',
                              height: 80,
                            ),
                          ),
                          const SizedBox(height: 24),
                    
                          Text(
                            "We value your feedback",
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: kBlackColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Have a suggestion or found a bug? Let us know below.",
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: kBlackColor.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 24),
                    
                          // Input Field
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: kWhiteColor.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: kBlackColor.withValues(alpha: 0.1)),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  textSelectionTheme: TextSelectionThemeData(
                                    cursorColor: kBlackColor,
                                    selectionHandleColor: kBlackColor,
                                    selectionColor: kBlackColor.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: TextField(
                                  controller: _feedbackController,
                                  maxLines: null,
                                  expands: true,
                                  style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: kBlackColor,
                                  ),
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: InputDecoration(
                                    hintText: "Type your feedback here...",
                                    hintStyle: GoogleFonts.manrope(
                                      color: kBlackColor.withValues(alpha: 0.4),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                    
                          // Submit Button
                          ContinueButton(
                            text: _isLoading ? "Sending..." : "Send Feedback",
                            isEnabled: !_isLoading,
                            onTap: _sendFeedback,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
