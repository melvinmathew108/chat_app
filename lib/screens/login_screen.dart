import 'package:chat_app/providers/app_provider.dart';
import 'package:chat_app/widgets/otp_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'user_list_screen.dart'; // Update import
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _otpController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _generatedOtp;
  bool _otpSent = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _otpSnackbar;
  final _formKey = GlobalKey<FormState>();
  bool _isValidPhoneNumber = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    _generatedOtp = (Random().nextInt(900000) + 100000).toString();
    _showOtpNotification(_generatedOtp!);

    _otpSnackbar?.close();
    _otpSnackbar = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Your OTP is: $_generatedOtp',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryPink,
        duration: const Duration(days: 1),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () => _otpSnackbar?.close(),
        ),
      ),
    );

    setState(() => _otpSent = true);
  }

  Future<void> _showOtpNotification(String otp) async {
    const androidDetails = AndroidNotificationDetails(
      'otp_channel',
      'OTP Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Your OTP Code',
      'Use this code to login: $otp',
      details,
    );
    print('OTP: $otp');
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length == 6 &&
        _otpController.text == _generatedOtp) {
      // Close the OTP SnackBar
      _otpSnackbar?.close();

      await context.read<AppProvider>().login(_phoneController.text);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserListScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _otpSnackbar?.close();
    super.dispose();
  }

  bool _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return false;
    // Indian phone number validation (10 digits)
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    return phoneRegex.hasMatch(value);
  }

  Widget _buildPhoneInputSection() {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 90,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: '+91',
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 28,
                      color: AppTheme.darkText,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    items: const [
                      DropdownMenuItem(
                        value: '+91',
                        child: Text(
                          '+91',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.darkText,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 24,
                color: Colors.grey,
                margin: const EdgeInsets.symmetric(vertical: 12),
              ),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.darkText,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    counterText: '',
                    hintStyle: TextStyle(
                      color: AppTheme.textGray.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                  validator: (value) {
                    if (!_validatePhoneNumber(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _isValidPhoneNumber = _validatePhoneNumber(value);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleEdit() {
    setState(() {
      _otpSent = false;
      _otpController.clear();
      _generatedOtp = null;
    });
    _otpSnackbar?.close();
  }

  Widget _buildOtpSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Enter verification code',
          style: AppTheme.titleText,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        // Phone number with edit option
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.lightGray.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '+91 ${_phoneController.text}',
                style: AppTheme.regularText.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _handleEdit,
                child: Text(
                  'Edit',
                  style: AppTheme.regularText.copyWith(
                    color: AppTheme.primaryPink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.offWhite,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: OtpInput(
            controller: _otpController,
            onCompleted: (value) => _verifyOtp(),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Didn\'t receive the code?',
          style: AppTheme.regularText.copyWith(
            color: AppTheme.textGray,
          ),
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: _sendOtp,
          child: Text(
            'Resend Code',
            style: AppTheme.regularText.copyWith(
              color: AppTheme.primaryPink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _verifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPink,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: const Text(
              'Verify',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  if (!_otpSent) ...[
                    Text(
                      'Enter your phone\nnumber',
                      style: AppTheme.titleText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    _buildPhoneInputSection(),
                    const SizedBox(height: 16),
                    Text(
                      'Fliq will send you a text with a verification code',
                      style: AppTheme.regularText.copyWith(
                        color: AppTheme.textGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isValidPhoneNumber ? _sendOtp : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPink,
                          disabledBackgroundColor:
                              AppTheme.primaryPink.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ] else
                    Expanded(child: _buildOtpSection()),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
